import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_record.freezed.dart';
part 'exercise_record.g.dart';

@freezed
class ExerciseRecord with _$ExerciseRecord {
  const factory ExerciseRecord({
    required String id,
    required DateTime recordedAt,
    required String exerciseType,
    required String exerciseName,
    required int duration, // in minutes
    required double caloriesBurned,
    double? distance, // in km
    int? sets,
    int? reps,
    double? weight, // in kg for strength training
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExerciseRecord;

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) =>
      _$ExerciseRecordFromJson(json);
}

// Common exercise types
class ExerciseType {
  static const String cardio = 'cardio';
  static const String strength = 'strength';
  static const String flexibility = 'flexibility';
  static const String sports = 'sports';
  static const String other = 'other';
}