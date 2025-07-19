// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WeeklyStats _$WeeklyStatsFromJson(Map<String, dynamic> json) {
  return _WeeklyStats.fromJson(json);
}

/// @nodoc
mixin _$WeeklyStats {
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  List<DailyStats> get dailyStats => throw _privateConstructorUsedError;
  double get averageCalories => throw _privateConstructorUsedError;
  double get totalCalories => throw _privateConstructorUsedError;
  double get targetCalories => throw _privateConstructorUsedError;
  int get totalMeals => throw _privateConstructorUsedError;
  Map<String, double> get nutritionAverages =>
      throw _privateConstructorUsedError; // daily averages for protein, carbs, fat
  List<double> get caloriesTrend => throw _privateConstructorUsedError;

  /// Serializes this WeeklyStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WeeklyStatsCopyWith<WeeklyStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyStatsCopyWith<$Res> {
  factory $WeeklyStatsCopyWith(
          WeeklyStats value, $Res Function(WeeklyStats) then) =
      _$WeeklyStatsCopyWithImpl<$Res, WeeklyStats>;
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      List<DailyStats> dailyStats,
      double averageCalories,
      double totalCalories,
      double targetCalories,
      int totalMeals,
      Map<String, double> nutritionAverages,
      List<double> caloriesTrend});
}

/// @nodoc
class _$WeeklyStatsCopyWithImpl<$Res, $Val extends WeeklyStats>
    implements $WeeklyStatsCopyWith<$Res> {
  _$WeeklyStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? dailyStats = null,
    Object? averageCalories = null,
    Object? totalCalories = null,
    Object? targetCalories = null,
    Object? totalMeals = null,
    Object? nutritionAverages = null,
    Object? caloriesTrend = null,
  }) {
    return _then(_value.copyWith(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as List<DailyStats>,
      averageCalories: null == averageCalories
          ? _value.averageCalories
          : averageCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalMeals: null == totalMeals
          ? _value.totalMeals
          : totalMeals // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionAverages: null == nutritionAverages
          ? _value.nutritionAverages
          : nutritionAverages // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      caloriesTrend: null == caloriesTrend
          ? _value.caloriesTrend
          : caloriesTrend // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyStatsImplCopyWith<$Res>
    implements $WeeklyStatsCopyWith<$Res> {
  factory _$$WeeklyStatsImplCopyWith(
          _$WeeklyStatsImpl value, $Res Function(_$WeeklyStatsImpl) then) =
      __$$WeeklyStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime startDate,
      DateTime endDate,
      List<DailyStats> dailyStats,
      double averageCalories,
      double totalCalories,
      double targetCalories,
      int totalMeals,
      Map<String, double> nutritionAverages,
      List<double> caloriesTrend});
}

/// @nodoc
class __$$WeeklyStatsImplCopyWithImpl<$Res>
    extends _$WeeklyStatsCopyWithImpl<$Res, _$WeeklyStatsImpl>
    implements _$$WeeklyStatsImplCopyWith<$Res> {
  __$$WeeklyStatsImplCopyWithImpl(
      _$WeeklyStatsImpl _value, $Res Function(_$WeeklyStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? dailyStats = null,
    Object? averageCalories = null,
    Object? totalCalories = null,
    Object? targetCalories = null,
    Object? totalMeals = null,
    Object? nutritionAverages = null,
    Object? caloriesTrend = null,
  }) {
    return _then(_$WeeklyStatsImpl(
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dailyStats: null == dailyStats
          ? _value._dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as List<DailyStats>,
      averageCalories: null == averageCalories
          ? _value.averageCalories
          : averageCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalCalories: null == totalCalories
          ? _value.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as double,
      targetCalories: null == targetCalories
          ? _value.targetCalories
          : targetCalories // ignore: cast_nullable_to_non_nullable
              as double,
      totalMeals: null == totalMeals
          ? _value.totalMeals
          : totalMeals // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionAverages: null == nutritionAverages
          ? _value._nutritionAverages
          : nutritionAverages // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      caloriesTrend: null == caloriesTrend
          ? _value._caloriesTrend
          : caloriesTrend // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyStatsImpl implements _WeeklyStats {
  const _$WeeklyStatsImpl(
      {required this.startDate,
      required this.endDate,
      required final List<DailyStats> dailyStats,
      required this.averageCalories,
      required this.totalCalories,
      required this.targetCalories,
      required this.totalMeals,
      required final Map<String, double> nutritionAverages,
      required final List<double> caloriesTrend})
      : _dailyStats = dailyStats,
        _nutritionAverages = nutritionAverages,
        _caloriesTrend = caloriesTrend;

  factory _$WeeklyStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyStatsImplFromJson(json);

  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  final List<DailyStats> _dailyStats;
  @override
  List<DailyStats> get dailyStats {
    if (_dailyStats is EqualUnmodifiableListView) return _dailyStats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyStats);
  }

  @override
  final double averageCalories;
  @override
  final double totalCalories;
  @override
  final double targetCalories;
  @override
  final int totalMeals;
  final Map<String, double> _nutritionAverages;
  @override
  Map<String, double> get nutritionAverages {
    if (_nutritionAverages is EqualUnmodifiableMapView)
      return _nutritionAverages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nutritionAverages);
  }

// daily averages for protein, carbs, fat
  final List<double> _caloriesTrend;
// daily averages for protein, carbs, fat
  @override
  List<double> get caloriesTrend {
    if (_caloriesTrend is EqualUnmodifiableListView) return _caloriesTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_caloriesTrend);
  }

  @override
  String toString() {
    return 'WeeklyStats(startDate: $startDate, endDate: $endDate, dailyStats: $dailyStats, averageCalories: $averageCalories, totalCalories: $totalCalories, targetCalories: $targetCalories, totalMeals: $totalMeals, nutritionAverages: $nutritionAverages, caloriesTrend: $caloriesTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyStatsImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._dailyStats, _dailyStats) &&
            (identical(other.averageCalories, averageCalories) ||
                other.averageCalories == averageCalories) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.targetCalories, targetCalories) ||
                other.targetCalories == targetCalories) &&
            (identical(other.totalMeals, totalMeals) ||
                other.totalMeals == totalMeals) &&
            const DeepCollectionEquality()
                .equals(other._nutritionAverages, _nutritionAverages) &&
            const DeepCollectionEquality()
                .equals(other._caloriesTrend, _caloriesTrend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_dailyStats),
      averageCalories,
      totalCalories,
      targetCalories,
      totalMeals,
      const DeepCollectionEquality().hash(_nutritionAverages),
      const DeepCollectionEquality().hash(_caloriesTrend));

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      __$$WeeklyStatsImplCopyWithImpl<_$WeeklyStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyStatsImplToJson(
      this,
    );
  }
}

abstract class _WeeklyStats implements WeeklyStats {
  const factory _WeeklyStats(
      {required final DateTime startDate,
      required final DateTime endDate,
      required final List<DailyStats> dailyStats,
      required final double averageCalories,
      required final double totalCalories,
      required final double targetCalories,
      required final int totalMeals,
      required final Map<String, double> nutritionAverages,
      required final List<double> caloriesTrend}) = _$WeeklyStatsImpl;

  factory _WeeklyStats.fromJson(Map<String, dynamic> json) =
      _$WeeklyStatsImpl.fromJson;

  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  List<DailyStats> get dailyStats;
  @override
  double get averageCalories;
  @override
  double get totalCalories;
  @override
  double get targetCalories;
  @override
  int get totalMeals;
  @override
  Map<String, double>
      get nutritionAverages; // daily averages for protein, carbs, fat
  @override
  List<double> get caloriesTrend;

  /// Create a copy of WeeklyStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WeeklyStatsImplCopyWith<_$WeeklyStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
