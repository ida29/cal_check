// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      activityLevel: $enumDecode(_$ActivityLevelEnumMap, json['activityLevel']),
      targetCalories: (json['targetCalories'] as num).toDouble(),
      isFirstTimeUser: json['isFirstTimeUser'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'gender': _$GenderEnumMap[instance.gender]!,
      'height': instance.height,
      'weight': instance.weight,
      'activityLevel': _$ActivityLevelEnumMap[instance.activityLevel]!,
      'targetCalories': instance.targetCalories,
      'isFirstTimeUser': instance.isFirstTimeUser,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.sedentary: 'sedentary',
  ActivityLevel.lightlyActive: 'lightlyActive',
  ActivityLevel.moderatelyActive: 'moderatelyActive',
  ActivityLevel.veryActive: 'veryActive',
  ActivityLevel.extraActive: 'extraActive',
};
