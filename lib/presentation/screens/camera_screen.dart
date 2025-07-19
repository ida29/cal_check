import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile photo = await _controller!.takePicture();
      
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/result',
          arguments: {'imagePath': photo.path},
        );
      }
    } catch (e) {
      print('Error taking picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to take picture')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Take a Photo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_off),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isInitialized && _controller != null)
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: CameraPreview(_controller!),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    color: Colors.white,
                    iconSize: 32,
                    onPressed: _pickFromGallery,
                  ),
                  GestureDetector(
                    onTap: _isProcessing ? null : _takePicture,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: _isProcessing ? Colors.grey : Colors.white,
                      ),
                      child: _isProcessing
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(
                              Icons.camera,
                              size: 40,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    color: Colors.white,
                    iconSize: 32,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Tips for Best Results'),
                          content: const Text(
                            '• Ensure good lighting\n'
                            '• Center the food in frame\n'
                            '• Avoid shadows\n'
                            '• Capture all items clearly\n'
                            '• Keep camera steady',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}