// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  String get id => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  MealType get mealType => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  List<FoodItem> get foodItems => throw _privateConstructorUsedError;
  double get totalCalories => throw _privateConstructorUsedError;
  NutritionInfo get totalNutrition => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      MealType mealType,
      String imagePath,
      List<FoodItem> foodItems,
      double totalCalories,
      NutritionInfo totalNutrition,
      String? notes,
      bool isSynced});

  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? mealType = null,
    Object? imagePath = null,
    Object? foodItems = null,
    Object? totalCalories = null,
    Object? totalNutrition = null,
    Object? notes = freezed,
    Object? isSynced = null,
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
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Meal
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
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      MealType mealType,
      String imagePath,
      List<FoodItem> foodItems,
      double totalCalories,
      NutritionInfo totalNutrition,
      String? notes,
      bool isSynced});

  @override
  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? mealType = null,
    Object? imagePath = null,
    Object? foodItems = null,
    Object? totalCalories = null,
    Object? totalNutrition = null,
    Object? notes = freezed,
    Object? isSynced = null,
  }) {
    return _then(_$MealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mealType: null == mealType
          ? _value.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as MealType,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MealImpl implements _Meal {
  const _$MealImpl(
      {required this.id,
      required this.timestamp,
      required this.mealType,
      required this.imagePath,
      required final List<FoodItem> foodItems,
      required this.totalCalories,
      required this.totalNutrition,
      this.notes,
      this.isSynced = false})
      : _foodItems = foodItems;

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime timestamp;
  @override
  final MealType mealType;
  @override
  final String imagePath;
  final List<FoodItem> _foodItems;
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
  final String? notes;
  @override
  @JsonKey()
  final bool isSynced;

  @override
  String toString() {
    return 'Meal(id: $id, timestamp: $timestamp, mealType: $mealType, imagePath: $imagePath, foodItems: $foodItems, totalCalories: $totalCalories, totalNutrition: $totalNutrition, notes: $notes, isSynced: $isSynced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            const DeepCollectionEquality()
                .equals(other._foodItems, _foodItems) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.totalNutrition, totalNutrition) ||
                other.totalNutrition == totalNutrition) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      timestamp,
      mealType,
      imagePath,
      const DeepCollectionEquality().hash(_foodItems),
      totalCalories,
      totalNutrition,
      notes,
      isSynced);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {required final String id,
      required final DateTime timestamp,
      required final MealType mealType,
      required final String imagePath,
      required final List<FoodItem> foodItems,
      required final double totalCalories,
      required final NutritionInfo totalNutrition,
      final String? notes,
      final bool isSynced}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get timestamp;
  @override
  MealType get mealType;
  @override
  String get imagePath;
  @override
  List<FoodItem> get foodItems;
  @override
  double get totalCalories;
  @override
  NutritionInfo get totalNutrition;
  @override
  String? get notes;
  @override
  bool get isSynced;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
