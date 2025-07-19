// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeightRecord _$WeightRecordFromJson(Map<String, dynamic> json) {
  return _WeightRecord.fromJson(json);
}

/// @nodoc
mixin _$WeightRecord {
  String get id => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  double get weight => throw _privateConstructorUsedError; // in kg
  double? get bodyFat => throw _privateConstructorUsedError; // percentage
  double? get muscleMass => throw _privateConstructorUsedError; // in kg
  String? get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this WeightRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeightRecordCopyWith<WeightRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeightRecordCopyWith<$Res> {
  factory $WeightRecordCopyWith(
          WeightRecord value, $Res Function(WeightRecord) then) =
      _$WeightRecordCopyWithImpl<$Res, WeightRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      double weight,
      double? bodyFat,
      double? muscleMass,
      String? note,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$WeightRecordCopyWithImpl<$Res, $Val extends WeightRecord>
    implements $WeightRecordCopyWith<$Res> {
  _$WeightRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? weight = null,
    Object? bodyFat = freezed,
    Object? muscleMass = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeightRecordImplCopyWith<$Res>
    implements $WeightRecordCopyWith<$Res> {
  factory _$$WeightRecordImplCopyWith(
          _$WeightRecordImpl value, $Res Function(_$WeightRecordImpl) then) =
      __$$WeightRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      double weight,
      double? bodyFat,
      double? muscleMass,
      String? note,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$WeightRecordImplCopyWithImpl<$Res>
    extends _$WeightRecordCopyWithImpl<$Res, _$WeightRecordImpl>
    implements _$$WeightRecordImplCopyWith<$Res> {
  __$$WeightRecordImplCopyWithImpl(
      _$WeightRecordImpl _value, $Res Function(_$WeightRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? weight = null,
    Object? bodyFat = freezed,
    Object? muscleMass = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$WeightRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weight: null == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double,
      bodyFat: freezed == bodyFat
          ? _value.bodyFat
          : bodyFat // ignore: cast_nullable_to_non_nullable
              as double?,
      muscleMass: freezed == muscleMass
          ? _value.muscleMass
          : muscleMass // ignore: cast_nullable_to_non_nullable
              as double?,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeightRecordImpl implements _WeightRecord {
  const _$WeightRecordImpl(
      {required this.id,
      required this.recordedAt,
      required this.weight,
      this.bodyFat,
      this.muscleMass,
      this.note,
      this.createdAt,
      this.updatedAt});

  factory _$WeightRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeightRecordImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime recordedAt;
  @override
  final double weight;
// in kg
  @override
  final double? bodyFat;
// percentage
  @override
  final double? muscleMass;
// in kg
  @override
  final String? note;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'WeightRecord(id: $id, recordedAt: $recordedAt, weight: $weight, bodyFat: $bodyFat, muscleMass: $muscleMass, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeightRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.bodyFat, bodyFat) || other.bodyFat == bodyFat) &&
            (identical(other.muscleMass, muscleMass) ||
                other.muscleMass == muscleMass) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, recordedAt, weight, bodyFat,
      muscleMass, note, createdAt, updatedAt);

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      __$$WeightRecordImplCopyWithImpl<_$WeightRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeightRecordImplToJson(
      this,
    );
  }
}

abstract class _WeightRecord implements WeightRecord {
  const factory _WeightRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final double weight,
      final double? bodyFat,
      final double? muscleMass,
      final String? note,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$WeightRecordImpl;

  factory _WeightRecord.fromJson(Map<String, dynamic> json) =
      _$WeightRecordImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get recordedAt;
  @override
  double get weight; // in kg
  @override
  double? get bodyFat; // percentage
  @override
  double? get muscleMass; // in kg
  @override
  String? get note;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of WeightRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeightRecordImplCopyWith<_$WeightRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
