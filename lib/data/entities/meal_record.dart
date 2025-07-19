import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_item.dart';
import 'nutrition_info.dart';

part 'meal_record.freezed.dart';
part 'meal_record.g.dart';

@freezed
class MealRecord with _$MealRecord {
  const factory MealRecord({
    required String id,
    required DateTime recordedAt,
    required String mealType, // breakfast, lunch, dinner, snack
    required List<FoodItem> foodItems,
    required double totalCalories,
    required NutritionInfo totalNutrition,
    String? photoPath,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MealRecord;

  factory MealRecord.fromJson(Map<String, dynamic> json) =>
      _$MealRecordFromJson(json);
}