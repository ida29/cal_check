import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

enum ExerciseType { 
  cardio, 
  strength, 
  flexibility, 
  sports, 
  walking, 
  running, 
  cycling, 
  swimming, 
  other 
}

enum ExerciseIntensity { low, moderate, high }

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required DateTime timestamp,
    required ExerciseType type,
    required String name,
    required int durationMinutes,
    required double caloriesBurned,
    required ExerciseIntensity intensity,
    String? notes,
    int? sets,
    int? reps,
    double? weight,
    double? distance,
    @Default(false) bool isSynced,
    @Default(false) bool isManualEntry,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}