import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/image_recognition_service.dart';
import '../models/recognition_result.dart';

final imageRecognitionServiceProvider = Provider<ImageRecognitionService>((ref) {
  return ImageRecognitionService();
});

final recognitionResultProvider = StateNotifierProvider<RecognitionNotifier, AsyncValue<RecognitionResult?>>((ref) {
  return RecognitionNotifier(ref.watch(imageRecognitionServiceProvider));
});

class RecognitionNotifier extends StateNotifier<AsyncValue<RecognitionResult?>> {
  final ImageRecognitionService _recognitionService;

  RecognitionNotifier(this._recognitionService) : super(const AsyncValue.data(null));

  Future<void> recognizeFood(String imagePath) async {
    state = const AsyncValue.loading();
    try {
      final result = await _recognitionService.recognizeFood(imagePath);
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearResult() {
    state = const AsyncValue.data(null);
  }

  @override
  void dispose() {
    _recognitionService.dispose();
    super.dispose();
  }
}