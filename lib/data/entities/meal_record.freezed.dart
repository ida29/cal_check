// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MealRecord _$MealRecordFromJson(Map<String, dynamic> json) {
  return _MealRecord.fromJson(json);
}

/// @nodoc
mixin _$MealRecord {
  String get id => throw _privateConstructorUsedError;
  DateTime get recordedAt => throw _privateConstructorUsedError;
  String get mealType =>
      throw _privateConstructorUsedError; // breakfast, lunch, dinner, snack
  List<FoodItem> get foodItems => throw _privateConstructorUsedError;
  double get totalCalories => throw _privateConstructorUsedError;
  NutritionInfo get totalNutrition => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this MealRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealRecordCopyWith<MealRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealRecordCopyWith<$Res> {
  factory $MealRecordCopyWith(
          MealRecord value, $Res Function(MealRecord) then) =
      _$MealRecordCopyWithImpl<$Res, MealRecord>;
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      String mealType,
      List<FoodItem> foodItems,
      double totalCalories,
      NutritionInfo totalNutrition,
      String? photoPath,
      String? note,
      DateTime? createdAt,
      DateTime? updatedAt});

  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class _$MealRecordCopyWithImpl<$Res, $Val extends MealRecord>
    implements $MealRecordCopyWith<$Res> {
  _$MealRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? mealType = null,
    Object? foodItems = null,
    Object? totalCalories = null,
    Object? totalNutrition = null,
    Object? photoPath = freezed,
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
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      foodItems: null == foodItems
          ? _value.foodItems
          : foodItems // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as NutritionInfo,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
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

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionInfoCopyWith<$Res> get totalNutrition {
    return $NutritionInfoCopyWith<$Res>(_value.totalNutrition, (value) {
      return _then(_value.copyWith(totalNutrition: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MealRecordImplCopyWith<$Res>
    implements $MealRecordCopyWith<$Res> {
  factory _$$MealRecordImplCopyWith(
          _$MealRecordImpl value, $Res Function(_$MealRecordImpl) then) =
      __$$MealRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime recordedAt,
      String mealType,
      List<FoodItem> foodItems,
      double totalCalories,
      NutritionInfo totalNutrition,
      String? photoPath,
      String? note,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class __$$MealRecordImplCopyWithImpl<$Res>
    extends _$MealRecordCopyWithImpl<$Res, _$MealRecordImpl>
    implements _$$MealRecordImplCopyWith<$Res> {
  __$$MealRecordImplCopyWithImpl(
      _$MealRecordImpl _value, $Res Function(_$MealRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recordedAt = null,
    Object? mealType = null,
    Object? foodItems = null,
    Object? totalCalories = null,
    Object? totalNutrition = null,
    Object? photoPath = freezed,
    Object? note = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MealRecordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recordedAt: null == recordedAt
          ? _value.recordedAt
          : recordedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      foodItems: null == foodItems
          ? _value._foodItems
          : foodItems // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as NutritionInfo,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$MealRecordImpl implements _MealRecord {
  const _$MealRecordImpl(
      {required this.id,
      required this.recordedAt,
      required this.mealType,
      required final List<FoodItem> foodItems,
      required this.totalCalories,
      required this.totalNutrition,
      this.photoPath,
      this.note,
      this.createdAt,
      this.updatedAt})
      : _foodItems = foodItems;

  factory _$MealRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealRecordImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime recordedAt;
  @override
  final String mealType;
// breakfast, lunch, dinner, snack
  final List<FoodItem> _foodItems;
// breakfast, lunch, dinner, snack
  @override
  List<FoodItem> get foodItems {
    if (_foodItems is EqualUnmodifiableListView) return _foodItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foodItems);
  }

  @override
  final double totalCalories;
  @override
  final NutritionInfo totalNutrition;
  @override
  final String? photoPath;
  @override
  final String? note;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MealRecord(id: $id, recordedAt: $recordedAt, mealType: $mealType, foodItems: $foodItems, totalCalories: $totalCalories, totalNutrition: $totalNutrition, photoPath: $photoPath, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recordedAt, recordedAt) ||
                other.recordedAt == recordedAt) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            const DeepCollectionEquality()
                .equals(other._foodItems, _foodItems) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.totalNutrition, totalNutrition) ||
                other.totalNutrition == totalNutrition) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recordedAt,
      mealType,
      const DeepCollectionEquality().hash(_foodItems),
      totalCalories,
      totalNutrition,
      photoPath,
      note,
      createdAt,
      updatedAt);

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      __$$MealRecordImplCopyWithImpl<_$MealRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealRecordImplToJson(
      this,
    );
  }
}

abstract class _MealRecord implements MealRecord {
  const factory _MealRecord(
      {required final String id,
      required final DateTime recordedAt,
      required final String mealType,
      required final List<FoodItem> foodItems,
      required final double totalCalories,
      required final NutritionInfo totalNutrition,
      final String? photoPath,
      final String? note,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MealRecordImpl;

  factory _MealRecord.fromJson(Map<String, dynamic> json) =
      _$MealRecordImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get recordedAt;
  @override
  String get mealType; // breakfast, lunch, dinner, snack
  @override
  List<FoodItem> get foodItems;
  @override
  double get totalCalories;
  @override
  NutritionInfo get totalNutrition;
  @override
  String? get photoPath;
  @override
  String? get note;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of MealRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealRecordImplCopyWith<_$MealRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
