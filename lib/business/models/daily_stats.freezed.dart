// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyStats _$DailyStatsFromJson(Map<String, dynamic> json) {
  return _DailyStats.fromJson(json);
}

/// @nodoc
mixin _$DailyStats {
  DateTime get date => throw _privateConstructorUsedError;
  double get totalCalories => throw _privateConstructorUsedError;
  double get targetCalories => throw _privateConstructorUsedError;
  NutritionInfo get totalNutrition => throw _privateConstructorUsedError;
  int get mealCount => throw _privateConstructorUsedError;
  Map<String, double> get mealTypeBreakdown =>
      throw _privateConstructorUsedError; // breakfast, lunch, dinner, snack percentages
  double get calorieGoalProgress => throw _privateConstructorUsedError;

  /// Serializes this DailyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyStatsCopyWith<DailyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyStatsCopyWith<$Res> {
  factory $DailyStatsCopyWith(
          DailyStats value, $Res Function(DailyStats) then) =
      _$DailyStatsCopyWithImpl<$Res, DailyStats>;
  @useResult
  $Res call(
      {DateTime date,
      double totalCalories,
      double targetCalories,
      NutritionInfo totalNutrition,
      int mealCount,
      Map<String, double> mealTypeBreakdown,
      double calorieGoalProgress});

  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class _$DailyStatsCopyWithImpl<$Res, $Val extends DailyStats>
    implements $DailyStatsCopyWith<$Res> {
  _$DailyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalCalories = null,
    Object? targetCalories = null,
    Object? totalNutrition = null,
    Object? mealCount = null,
    Object? mealTypeBreakdown = null,
    Object? calorieGoalProgress = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as NutritionInfo,
      mealCount: null == mealCount
          ? _value.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as int,
      mealTypeBreakdown: null == mealTypeBreakdown
          ? _value.mealTypeBreakdown
          : mealTypeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      calorieGoalProgress: null == calorieGoalProgress
          ? _value.calorieGoalProgress
          : calorieGoalProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of DailyStats
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
abstract class _$$DailyStatsImplCopyWith<$Res>
    implements $DailyStatsCopyWith<$Res> {
  factory _$$DailyStatsImplCopyWith(
          _$DailyStatsImpl value, $Res Function(_$DailyStatsImpl) then) =
      __$$DailyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime date,
      double totalCalories,
      double targetCalories,
      NutritionInfo totalNutrition,
      int mealCount,
      Map<String, double> mealTypeBreakdown,
      double calorieGoalProgress});

  @override
  $NutritionInfoCopyWith<$Res> get totalNutrition;
}

/// @nodoc
class __$$DailyStatsImplCopyWithImpl<$Res>
    extends _$DailyStatsCopyWithImpl<$Res, _$DailyStatsImpl>
    implements _$$DailyStatsImplCopyWith<$Res> {
  __$$DailyStatsImplCopyWithImpl(
      _$DailyStatsImpl _value, $Res Function(_$DailyStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? totalCalories = null,
    Object? targetCalories = null,
    Object? totalNutrition = null,
    Object? mealCount = null,
    Object? mealTypeBreakdown = null,
    Object? calorieGoalProgress = null,
  }) {
    return _then(_$DailyStatsImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalNutrition: null == totalNutrition
          ? _value.totalNutrition
          : totalNutrition // ignore: cast_nullable_to_non_nullable
              as NutritionInfo,
      mealCount: null == mealCount
          ? _value.mealCount
          : mealCount // ignore: cast_nullable_to_non_nullable
              as int,
      mealTypeBreakdown: null == mealTypeBreakdown
          ? _value._mealTypeBreakdown
          : mealTypeBreakdown // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      calorieGoalProgress: null == calorieGoalProgress
          ? _value.calorieGoalProgress
          : calorieGoalProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyStatsImpl implements _DailyStats {
  const _$DailyStatsImpl(
      {required this.date,
      required this.totalCalories,
      required this.targetCalories,
      required this.totalNutrition,
      required this.mealCount,
      required final Map<String, double> mealTypeBreakdown,
      this.calorieGoalProgress = 0.0})
      : _mealTypeBreakdown = mealTypeBreakdown;

  factory _$DailyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyStatsImplFromJson(json);

  @override
  final DateTime date;
  @override
  final double totalCalories;
  @override
  final double targetCalories;
  @override
  final NutritionInfo totalNutrition;
  @override
  final int mealCount;
  final Map<String, double> _mealTypeBreakdown;
  @override
  Map<String, double> get mealTypeBreakdown {
    if (_mealTypeBreakdown is EqualUnmodifiableMapView)
      return _mealTypeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_mealTypeBreakdown);
  }

// breakfast, lunch, dinner, snack percentages
  @override
  @JsonKey()
  final double calorieGoalProgress;

  @override
  String toString() {
    return 'DailyStats(date: $date, totalCalories: $totalCalories, targetCalories: $targetCalories, totalNutrition: $totalNutrition, mealCount: $mealCount, mealTypeBreakdown: $mealTypeBreakdown, calorieGoalProgress: $calorieGoalProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyStatsImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.targetCalories, targetCalories) ||
                other.targetCalories == targetCalories) &&
            (identical(other.totalNutrition, totalNutrition) ||
                other.totalNutrition == totalNutrition) &&
            (identical(other.mealCount, mealCount) ||
                other.mealCount == mealCount) &&
            const DeepCollectionEquality()
                .equals(other._mealTypeBreakdown, _mealTypeBreakdown) &&
            (identical(other.calorieGoalProgress, calorieGoalProgress) ||
                other.calorieGoalProgress == calorieGoalProgress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      date,
      totalCalories,
      targetCalories,
      totalNutrition,
      mealCount,
      const DeepCollectionEquality().hash(_mealTypeBreakdown),
      calorieGoalProgress);

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      __$$DailyStatsImplCopyWithImpl<_$DailyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyStatsImplToJson(
      this,
    );
  }
}

abstract class _DailyStats implements DailyStats {
  const factory _DailyStats(
      {required final DateTime date,
      required final double totalCalories,
      required final double targetCalories,
      required final NutritionInfo totalNutrition,
      required final int mealCount,
      required final Map<String, double> mealTypeBreakdown,
      final double calorieGoalProgress}) = _$DailyStatsImpl;

  factory _DailyStats.fromJson(Map<String, dynamic> json) =
      _$DailyStatsImpl.fromJson;

  @override
  DateTime get date;
  @override
  double get totalCalories;
  @override
  double get targetCalories;
  @override
  NutritionInfo get totalNutrition;
  @override
  int get mealCount;
  @override
  Map<String, double>
      get mealTypeBreakdown; // breakfast, lunch, dinner, snack percentages
  @override
  double get calorieGoalProgress;

  /// Create a copy of DailyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyStatsImplCopyWith<_$DailyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
