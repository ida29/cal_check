import 'package:freezed_annotation/freezed_annotation.dart';
import 'daily_stats.dart';

part 'weekly_stats.freezed.dart';
part 'weekly_stats.g.dart';

@freezed
class WeeklyStats with _$WeeklyStats {
  const factory WeeklyStats({
    required DateTime startDate,
    required DateTime endDate,
    required List<DailyStats> dailyStats,
    required double averageCalories,
    required double totalCalories,
    required double targetCalories,
    required int totalMeals,
    required Map<String, double> nutritionAverages, // daily averages for protein, carbs, fat
    required List<double> caloriesTrend, // 7 days of calorie values
  }) = _WeeklyStats;

  factory WeeklyStats.fromJson(Map<String, dynamic> json) =>
      _$WeeklyStatsFromJson(json);
}