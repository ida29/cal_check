import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});

final cameraControllerProvider = StateNotifierProvider<CameraNotifier, AsyncValue<CameraController?>>((ref) {
  return CameraNotifier(ref.watch(cameraServiceProvider));
});

final flashModeProvider = StateProvider<FlashMode>((ref) {
  return FlashMode.off;
});

class CameraNotifier extends StateNotifier<AsyncValue<CameraController?>> {
  final CameraService _cameraService;

  CameraNotifier(this._cameraService) : super(const AsyncValue.loading());

  Future<void> initializeCamera() async {
    state = const AsyncValue.loading();
    try {
      final success = await _cameraService.initialize();
      if (success) {
        state = AsyncValue.data(_cameraService.controller);
      } else {
        state = const AsyncValue.error('Failed to initialize camera', StackTrace.empty);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<String?> takePicture() async {
    try {
      return await _cameraService.takePicture();
    } catch (error) {
      return null;
    }
  }

  Future<String?> pickFromGallery() async {
    try {
      return await _cameraService.pickFromGallery();
    } catch (error) {
      return null;
    }
  }

  Future<void> switchCamera() async {
    try {
      await _cameraService.switchCamera();
      state = AsyncValue.data(_cameraService.controller);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await _cameraService.setFlashMode(mode);
    } catch (error) {
      // Handle error silently
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }
}