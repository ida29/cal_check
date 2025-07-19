// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyStatsImpl _$$WeeklyStatsImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyStatsImpl(
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      dailyStats: (json['dailyStats'] as List<dynamic>)
          .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageCalories: (json['averageCalories'] as num).toDouble(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      targetCalories: (json['targetCalories'] as num).toDouble(),
      totalMeals: (json['totalMeals'] as num).toInt(),
      nutritionAverages:
          (json['nutritionAverages'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      caloriesTrend: (json['caloriesTrend'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$WeeklyStatsImplToJson(_$WeeklyStatsImpl instance) =>
    <String, dynamic>{
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'dailyStats': instance.dailyStats,
      'averageCalories': instance.averageCalories,
      'totalCalories': instance.totalCalories,
      'targetCalories': instance.targetCalories,
      'totalMeals': instance.totalMeals,
      'nutritionAverages': instance.nutritionAverages,
      'caloriesTrend': instance.caloriesTrend,
    };
