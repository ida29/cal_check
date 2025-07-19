// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NutritionInfoImpl _$$NutritionInfoImplFromJson(Map<String, dynamic> json) =>
    _$NutritionInfoImpl(
      protein: (json['protein'] as num).toDouble(),
      carbohydrates: (json['carbohydrates'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      sodium: (json['sodium'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$NutritionInfoImplToJson(_$NutritionInfoImpl instance) =>
    <String, dynamic>{
      'protein': instance.protein,
      'carbohydrates': instance.carbohydrates,
      'fat': instance.fat,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
    };
