// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      mealType: $enumDecode(_$MealTypeEnumMap, json['mealType']),
      imagePath: json['imagePath'] as String,
      foodItems: (json['foodItems'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalNutrition: NutritionInfo.fromJson(
          json['totalNutrition'] as Map<String, dynamic>),
      notes: json['notes'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      isManualEntry: json['isManualEntry'] as bool? ?? false,
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'mealType': _$MealTypeEnumMap[instance.mealType]!,
      'imagePath': instance.imagePath,
      'foodItems': instance.foodItems,
      'totalCalories': instance.totalCalories,
      'totalNutrition': instance.totalNutrition,
      'notes': instance.notes,
      'isSynced': instance.isSynced,
      'isManualEntry': instance.isManualEntry,
    };

const _$MealTypeEnumMap = {
  MealType.breakfast: 'breakfast',
  MealType.lunch: 'lunch',
  MealType.dinner: 'dinner',
  MealType.snack: 'snack',
};
