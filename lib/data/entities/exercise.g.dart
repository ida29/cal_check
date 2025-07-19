// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
      name: json['name'] as String,
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      intensity: $enumDecode(_$ExerciseIntensityEnumMap, json['intensity']),
      notes: json['notes'] as String?,
      sets: (json['sets'] as num?)?.toInt(),
      reps: (json['reps'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      isSynced: json['isSynced'] as bool? ?? false,
      isManualEntry: json['isManualEntry'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': _$ExerciseTypeEnumMap[instance.type]!,
      'name': instance.name,
      'durationMinutes': instance.durationMinutes,
      'caloriesBurned': instance.caloriesBurned,
      'intensity': _$ExerciseIntensityEnumMap[instance.intensity]!,
      'notes': instance.notes,
      'sets': instance.sets,
      'reps': instance.reps,
      'weight': instance.weight,
      'distance': instance.distance,
      'isSynced': instance.isSynced,
      'isManualEntry': instance.isManualEntry,
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.cardio: 'cardio',
  ExerciseType.strength: 'strength',
  ExerciseType.flexibility: 'flexibility',
  ExerciseType.sports: 'sports',
  ExerciseType.walking: 'walking',
  ExerciseType.running: 'running',
  ExerciseType.cycling: 'cycling',
  ExerciseType.swimming: 'swimming',
  ExerciseType.other: 'other',
};

const _$ExerciseIntensityEnumMap = {
  ExerciseIntensity.low: 'low',
  ExerciseIntensity.moderate: 'moderate',
  ExerciseIntensity.high: 'high',
};
