// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealRecordImpl _$$MealRecordImplFromJson(Map<String, dynamic> json) =>
    _$MealRecordImpl(
      id: json['id'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      mealType: json['mealType'] as String,
      foodItems: (json['foodItems'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalNutrition: NutritionInfo.fromJson(
          json['totalNutrition'] as Map<String, dynamic>),
      photoPath: json['photoPath'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MealRecordImplToJson(_$MealRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'mealType': instance.mealType,
      'foodItems': instance.foodItems,
      'totalCalories': instance.totalCalories,
      'totalNutrition': instance.totalNutrition,
      'photoPath': instance.photoPath,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
