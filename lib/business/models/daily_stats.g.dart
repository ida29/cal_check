// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyStatsImpl _$$DailyStatsImplFromJson(Map<String, dynamic> json) =>
    _$DailyStatsImpl(
      date: DateTime.parse(json['date'] as String),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      targetCalories: (json['targetCalories'] as num).toDouble(),
      totalNutrition: NutritionInfo.fromJson(
          json['totalNutrition'] as Map<String, dynamic>),
      mealCount: (json['mealCount'] as num).toInt(),
      mealTypeBreakdown:
          (json['mealTypeBreakdown'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      calorieGoalProgress:
          (json['calorieGoalProgress'] as num?)?.toDouble() ?? 0.0,
      totalCaloriesBurned:
          (json['totalCaloriesBurned'] as num?)?.toDouble() ?? 0.0,
      exerciseCount: (json['exerciseCount'] as num?)?.toInt() ?? 0,
      totalExerciseMinutes:
          (json['totalExerciseMinutes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DailyStatsImplToJson(_$DailyStatsImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalCalories': instance.totalCalories,
      'targetCalories': instance.targetCalories,
      'totalNutrition': instance.totalNutrition,
      'mealCount': instance.mealCount,
      'mealTypeBreakdown': instance.mealTypeBreakdown,
      'calorieGoalProgress': instance.calorieGoalProgress,
      'totalCaloriesBurned': instance.totalCaloriesBurned,
      'exerciseCount': instance.exerciseCount,
      'totalExerciseMinutes': instance.totalExerciseMinutes,
    };
