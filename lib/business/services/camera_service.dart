import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CameraService {
  static final CameraService _instance = CameraService._internal();
  factory CameraService() => _instance;
  CameraService._internal();

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final ImagePicker _imagePicker = ImagePicker();

  bool get isInitialized => _controller?.value.isInitialized ?? false;
  CameraController? get controller => _controller;

  Future<bool> requestPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.storage.status;

    if (cameraStatus.isDenied) {
      final result = await Permission.camera.request();
      if (!result.isGranted) {
        return false;
      }
    }

    if (storageStatus.isDenied) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        return false;
      }
    }

    return true;
  }

  Future<bool> initialize() async {
    try {
      final hasPermissions = await requestPermissions();
      if (!hasPermissions) {
        throw Exception('Camera or storage permissions not granted');
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      return true;
    } catch (e) {
      print('Error initializing camera: $e');
      return false;
    }
  }

  Future<String?> takePicture() async {
    if (!isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      final XFile picture = await _controller!.takePicture();
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(directory.path, 'meals', fileName);
      
      await Directory(path.dirname(savedPath)).create(recursive: true);
      await File(picture.path).copy(savedPath);
      
      return savedPath;
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  Future<String?> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return null;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'meal_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = path.join(directory.path, 'meals', fileName);
      
      await Directory(path.dirname(savedPath)).create(recursive: true);
      await File(image.path).copy(savedPath);
      
      return savedPath;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentCameraIndex = _cameras!.indexOf(_controller!.description);
    final newCameraIndex = (currentCameraIndex + 1) % _cameras!.length;

    await _controller?.dispose();
    _controller = CameraController(
      _cameras![newCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (!isInitialized) return;
    await _controller!.setFlashMode(mode);
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  Future<void> cleanupOldImages({int maxAgeInDays = 30}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final mealsDir = Directory(path.join(directory.path, 'meals'));
      
      if (!await mealsDir.exists()) return;

      final cutoffDate = DateTime.now().subtract(Duration(days: maxAgeInDays));
      final files = await mealsDir.list().toList();

      for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          if (stat.modified.isBefore(cutoffDate)) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      print('Error cleaning up old images: $e');
    }
  }
}