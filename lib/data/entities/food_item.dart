import 'package:freezed_annotation/freezed_annotation.dart';
import 'nutrition_info.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String name,
    required double quantity,
    required String unit,
    required double calories,
    required NutritionInfo nutritionInfo,
    @Default(1.0) double confidenceScore,
    String? imageUrl,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}