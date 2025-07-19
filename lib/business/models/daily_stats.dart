import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/entities/nutrition_info.dart';

part 'daily_stats.freezed.dart';
part 'daily_stats.g.dart';

@freezed
class DailyStats with _$DailyStats {
  const factory DailyStats({
    required DateTime date,
    required double totalCalories,
    required double targetCalories,
    required NutritionInfo totalNutrition,
    required int mealCount,
    required Map<String, double> mealTypeBreakdown, // breakfast, lunch, dinner, snack percentages
    @Default(0.0) double calorieGoalProgress, // percentage
    @Default(0.0) double totalCaloriesBurned, // calories burned from exercise
    @Default(0) int exerciseCount,
    @Default(0) int totalExerciseMinutes,
  }) = _DailyStats;

  factory DailyStats.fromJson(Map<String, dynamic> json) =>
      _$DailyStatsFromJson(json);
}