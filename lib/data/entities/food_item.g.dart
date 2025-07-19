// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      calories: (json['calories'] as num).toDouble(),
      nutritionInfo:
          NutritionInfo.fromJson(json['nutritionInfo'] as Map<String, dynamic>),
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 1.0,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'calories': instance.calories,
      'nutritionInfo': instance.nutritionInfo,
      'confidenceScore': instance.confidenceScore,
      'imageUrl': instance.imageUrl,
    };
