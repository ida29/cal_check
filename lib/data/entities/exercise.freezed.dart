// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  ExerciseType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;
  double get caloriesBurned => throw _privateConstructorUsedError;
  ExerciseIntensity get intensity => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  int? get sets => throw _privateConstructorUsedError;
  int? get reps => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  double? get distance => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  bool get isManualEntry => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      ExerciseType type,
      String name,
      int durationMinutes,
      double caloriesBurned,
      ExerciseIntensity intensity,
      String? notes,
      int? sets,
      int? reps,
      double? weight,
      double? distance,
      bool isSynced,
      bool isManualEntry});
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? name = null,
    Object? durationMinutes = null,
    Object? caloriesBurned = null,
    Object? intensity = null,
    Object? notes = freezed,
    Object? sets = freezed,
    Object? reps = freezed,
    Object? weight = freezed,
    Object? distance = freezed,
    Object? isSynced = null,
    Object? isManualEntry = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExerciseType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as double,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as ExerciseIntensity,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sets: freezed == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isManualEntry: null == isManualEntry
          ? _value.isManualEntry
          : isManualEntry // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
          _$ExerciseImpl value, $Res Function(_$ExerciseImpl) then) =
      __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      ExerciseType type,
      String name,
      int durationMinutes,
      double caloriesBurned,
      ExerciseIntensity intensity,
      String? notes,
      int? sets,
      int? reps,
      double? weight,
      double? distance,
      bool isSynced,
      bool isManualEntry});
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
      _$ExerciseImpl _value, $Res Function(_$ExerciseImpl) _then)
      : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? type = null,
    Object? name = null,
    Object? durationMinutes = null,
    Object? caloriesBurned = null,
    Object? intensity = null,
    Object? notes = freezed,
    Object? sets = freezed,
    Object? reps = freezed,
    Object? weight = freezed,
    Object? distance = freezed,
    Object? isSynced = null,
    Object? isManualEntry = null,
  }) {
    return _then(_$ExerciseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ExerciseType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      caloriesBurned: null == caloriesBurned
          ? _value.caloriesBurned
          : caloriesBurned // ignore: cast_nullable_to_non_nullable
              as double,
      intensity: null == intensity
          ? _value.intensity
          : intensity // ignore: cast_nullable_to_non_nullable
              as ExerciseIntensity,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      sets: freezed == sets
          ? _value.sets
          : sets // ignore: cast_nullable_to_non_nullable
              as int?,
      reps: freezed == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isManualEntry: null == isManualEntry
          ? _value.isManualEntry
          : isManualEntry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl(
      {required this.id,
      required this.timestamp,
      required this.type,
      required this.name,
      required this.durationMinutes,
      required this.caloriesBurned,
      required this.intensity,
      this.notes,
      this.sets,
      this.reps,
      this.weight,
      this.distance,
      this.isSynced = false,
      this.isManualEntry = false});

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final ExerciseType type;
  @override
  final String name;
  @override
  final int durationMinutes;
  @override
  final double caloriesBurned;
  @override
  final ExerciseIntensity intensity;
  @override
  final String? notes;
  @override
  final int? sets;
  @override
  final int? reps;
  @override
  final double? weight;
  @override
  final double? distance;
  @override
  @JsonKey()
  final bool isSynced;
  @override
  @JsonKey()
  final bool isManualEntry;

  @override
  String toString() {
    return 'Exercise(id: $id, timestamp: $timestamp, type: $type, name: $name, durationMinutes: $durationMinutes, caloriesBurned: $caloriesBurned, intensity: $intensity, notes: $notes, sets: $sets, reps: $reps, weight: $weight, distance: $distance, isSynced: $isSynced, isManualEntry: $isManualEntry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.caloriesBurned, caloriesBurned) ||
                other.caloriesBurned == caloriesBurned) &&
            (identical(other.intensity, intensity) ||
                other.intensity == intensity) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.sets, sets) || other.sets == sets) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.isManualEntry, isManualEntry) ||
                other.isManualEntry == isManualEntry));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      timestamp,
      type,
      name,
      durationMinutes,
      caloriesBurned,
      intensity,
      notes,
      sets,
      reps,
      weight,
      distance,
      isSynced,
      isManualEntry);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(
      this,
    );
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise(
      {required final String id,
      required final DateTime timestamp,
      required final ExerciseType type,
      required final String name,
      required final int durationMinutes,
      required final double caloriesBurned,
      required final ExerciseIntensity intensity,
      final String? notes,
      final int? sets,
      final int? reps,
      final double? weight,
      final double? distance,
      final bool isSynced,
      final bool isManualEntry}) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  ExerciseType get type;
  @override
  String get name;
  @override
  int get durationMinutes;
  @override
  double get caloriesBurned;
  @override
  ExerciseIntensity get intensity;
  @override
  String? get notes;
  @override
  int? get sets;
  @override
  int? get reps;
  @override
  double? get weight;
  @override
  double? get distance;
  @override
  bool get isSynced;
  @override
  bool get isManualEntry;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
