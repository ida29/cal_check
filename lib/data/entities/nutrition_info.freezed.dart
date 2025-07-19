// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nutrition_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NutritionInfo _$NutritionInfoFromJson(Map<String, dynamic> json) {
  return _NutritionInfo.fromJson(json);
}

/// @nodoc
mixin _$NutritionInfo {
  double get protein => throw _privateConstructorUsedError;
  double get carbohydrates => throw _privateConstructorUsedError;
  double get fat => throw _privateConstructorUsedError;
  double get fiber => throw _privateConstructorUsedError;
  double get sugar => throw _privateConstructorUsedError;
  double get sodium => throw _privateConstructorUsedError;

  /// Serializes this NutritionInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionInfoCopyWith<NutritionInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionInfoCopyWith<$Res> {
  factory $NutritionInfoCopyWith(
          NutritionInfo value, $Res Function(NutritionInfo) then) =
      _$NutritionInfoCopyWithImpl<$Res, NutritionInfo>;
  @useResult
  $Res call(
      {double protein,
      double carbohydrates,
      double fat,
      double fiber,
      double sugar,
      double sodium});
}

/// @nodoc
class _$NutritionInfoCopyWithImpl<$Res, $Val extends NutritionInfo>
    implements $NutritionInfoCopyWith<$Res> {
  _$NutritionInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protein = null,
    Object? carbohydrates = null,
    Object? fat = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
  }) {
    return _then(_value.copyWith(
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbohydrates: null == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionInfoImplCopyWith<$Res>
    implements $NutritionInfoCopyWith<$Res> {
  factory _$$NutritionInfoImplCopyWith(
          _$NutritionInfoImpl value, $Res Function(_$NutritionInfoImpl) then) =
      __$$NutritionInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double protein,
      double carbohydrates,
      double fat,
      double fiber,
      double sugar,
      double sodium});
}

/// @nodoc
class __$$NutritionInfoImplCopyWithImpl<$Res>
    extends _$NutritionInfoCopyWithImpl<$Res, _$NutritionInfoImpl>
    implements _$$NutritionInfoImplCopyWith<$Res> {
  __$$NutritionInfoImplCopyWithImpl(
      _$NutritionInfoImpl _value, $Res Function(_$NutritionInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protein = null,
    Object? carbohydrates = null,
    Object? fat = null,
    Object? fiber = null,
    Object? sugar = null,
    Object? sodium = null,
  }) {
    return _then(_$NutritionInfoImpl(
      protein: null == protein
          ? _value.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      carbohydrates: null == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _value.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
      fiber: null == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double,
      sugar: null == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double,
      sodium: null == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionInfoImpl implements _NutritionInfo {
  const _$NutritionInfoImpl(
      {required this.protein,
      required this.carbohydrates,
      required this.fat,
      this.fiber = 0.0,
      this.sugar = 0.0,
      this.sodium = 0.0});

  factory _$NutritionInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionInfoImplFromJson(json);

  @override
  final double protein;
  @override
  final double carbohydrates;
  @override
  final double fat;
  @override
  @JsonKey()
  final double fiber;
  @override
  @JsonKey()
  final double sugar;
  @override
  @JsonKey()
  final double sodium;

  @override
  String toString() {
    return 'NutritionInfo(protein: $protein, carbohydrates: $carbohydrates, fat: $fat, fiber: $fiber, sugar: $sugar, sodium: $sodium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionInfoImpl &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.carbohydrates, carbohydrates) ||
                other.carbohydrates == carbohydrates) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.sodium, sodium) || other.sodium == sodium));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, protein, carbohydrates, fat, fiber, sugar, sodium);

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionInfoImplCopyWith<_$NutritionInfoImpl> get copyWith =>
      __$$NutritionInfoImplCopyWithImpl<_$NutritionInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionInfoImplToJson(
      this,
    );
  }
}

abstract class _NutritionInfo implements NutritionInfo {
  const factory _NutritionInfo(
      {required final double protein,
      required final double carbohydrates,
      required final double fat,
      final double fiber,
      final double sugar,
      final double sodium}) = _$NutritionInfoImpl;

  factory _NutritionInfo.fromJson(Map<String, dynamic> json) =
      _$NutritionInfoImpl.fromJson;

  @override
  double get protein;
  @override
  double get carbohydrates;
  @override
  double get fat;
  @override
  double get fiber;
  @override
  double get sugar;
  @override
  double get sodium;

  /// Create a copy of NutritionInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionInfoImplCopyWith<_$NutritionInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
