import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_item.dart';
import 'nutrition_info.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

enum MealType { breakfast, lunch, dinner, snack }

@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    required DateTime timestamp,
    required MealType mealType,
    required String imagePath,
    required List<FoodItem> foodItems,
    required double totalCalories,
    required NutritionInfo totalNutrition,
    String? notes,
    @Default(false) bool isSynced,
    @Default(false) bool isManualEntry,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) =>
      _$MealFromJson(json);
}