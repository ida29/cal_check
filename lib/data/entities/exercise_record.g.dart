// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseRecordImpl _$$ExerciseRecordImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseRecordImpl(
      id: json['id'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      exerciseType: json['exerciseType'] as String,
      exerciseName: json['exerciseName'] as String,
      duration: (json['duration'] as num).toInt(),
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      sets: (json['sets'] as num?)?.toInt(),
      reps: (json['reps'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      note: json['note'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ExerciseRecordImplToJson(
        _$ExerciseRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recordedAt': instance.recordedAt.toIso8601String(),
      'exerciseType': instance.exerciseType,
      'exerciseName': instance.exerciseName,
      'duration': instance.duration,
      'caloriesBurned': instance.caloriesBurned,
      'distance': instance.distance,
      'sets': instance.sets,
      'reps': instance.reps,
      'weight': instance.weight,
      'note': instance.note,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
