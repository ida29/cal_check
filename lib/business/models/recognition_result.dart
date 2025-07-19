import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/entities/food_item.dart';

part 'recognition_result.freezed.dart';
part 'recognition_result.g.dart';

@freezed
class RecognitionResult with _$RecognitionResult {
  const factory RecognitionResult({
    required String imagePath,
    required List<FoodItem> detectedItems,
    required double overallConfidence,
    required DateTime timestamp,
    @Default(false) bool requiresManualReview,
    String? errorMessage,
  }) = _RecognitionResult;

  factory RecognitionResult.fromJson(Map<String, dynamic> json) =>
      _$RecognitionResultFromJson(json);
}