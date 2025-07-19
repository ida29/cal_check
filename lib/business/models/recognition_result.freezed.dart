// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recognition_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecognitionResult _$RecognitionResultFromJson(Map<String, dynamic> json) {
  return _RecognitionResult.fromJson(json);
}

/// @nodoc
mixin _$RecognitionResult {
  String get imagePath => throw _privateConstructorUsedError;
  List<FoodItem> get detectedItems => throw _privateConstructorUsedError;
  double get overallConfidence => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get requiresManualReview => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this RecognitionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecognitionResultCopyWith<RecognitionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecognitionResultCopyWith<$Res> {
  factory $RecognitionResultCopyWith(
          RecognitionResult value, $Res Function(RecognitionResult) then) =
      _$RecognitionResultCopyWithImpl<$Res, RecognitionResult>;
  @useResult
  $Res call(
      {String imagePath,
      List<FoodItem> detectedItems,
      double overallConfidence,
      DateTime timestamp,
      bool requiresManualReview,
      String? errorMessage});
}

/// @nodoc
class _$RecognitionResultCopyWithImpl<$Res, $Val extends RecognitionResult>
    implements $RecognitionResultCopyWith<$Res> {
  _$RecognitionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? detectedItems = null,
    Object? overallConfidence = null,
    Object? timestamp = null,
    Object? requiresManualReview = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      detectedItems: null == detectedItems
          ? _value.detectedItems
          : detectedItems // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      overallConfidence: null == overallConfidence
          ? _value.overallConfidence
          : overallConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requiresManualReview: null == requiresManualReview
          ? _value.requiresManualReview
          : requiresManualReview // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecognitionResultImplCopyWith<$Res>
    implements $RecognitionResultCopyWith<$Res> {
  factory _$$RecognitionResultImplCopyWith(_$RecognitionResultImpl value,
          $Res Function(_$RecognitionResultImpl) then) =
      __$$RecognitionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imagePath,
      List<FoodItem> detectedItems,
      double overallConfidence,
      DateTime timestamp,
      bool requiresManualReview,
      String? errorMessage});
}

/// @nodoc
class __$$RecognitionResultImplCopyWithImpl<$Res>
    extends _$RecognitionResultCopyWithImpl<$Res, _$RecognitionResultImpl>
    implements _$$RecognitionResultImplCopyWith<$Res> {
  __$$RecognitionResultImplCopyWithImpl(_$RecognitionResultImpl _value,
      $Res Function(_$RecognitionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? detectedItems = null,
    Object? overallConfidence = null,
    Object? timestamp = null,
    Object? requiresManualReview = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$RecognitionResultImpl(
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      detectedItems: null == detectedItems
          ? _value._detectedItems
          : detectedItems // ignore: cast_nullable_to_non_nullable
              as List<FoodItem>,
      overallConfidence: null == overallConfidence
          ? _value.overallConfidence
          : overallConfidence // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      requiresManualReview: null == requiresManualReview
          ? _value.requiresManualReview
          : requiresManualReview // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecognitionResultImpl implements _RecognitionResult {
  const _$RecognitionResultImpl(
      {required this.imagePath,
      required final List<FoodItem> detectedItems,
      required this.overallConfidence,
      required this.timestamp,
      this.requiresManualReview = false,
      this.errorMessage})
      : _detectedItems = detectedItems;

  factory _$RecognitionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecognitionResultImplFromJson(json);

  @override
  final String imagePath;
  final List<FoodItem> _detectedItems;
  @override
  List<FoodItem> get detectedItems {
    if (_detectedItems is EqualUnmodifiableListView) return _detectedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detectedItems);
  }

  @override
  final double overallConfidence;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool requiresManualReview;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'RecognitionResult(imagePath: $imagePath, detectedItems: $detectedItems, overallConfidence: $overallConfidence, timestamp: $timestamp, requiresManualReview: $requiresManualReview, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecognitionResultImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            const DeepCollectionEquality()
                .equals(other._detectedItems, _detectedItems) &&
            (identical(other.overallConfidence, overallConfidence) ||
                other.overallConfidence == overallConfidence) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.requiresManualReview, requiresManualReview) ||
                other.requiresManualReview == requiresManualReview) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      imagePath,
      const DeepCollectionEquality().hash(_detectedItems),
      overallConfidence,
      timestamp,
      requiresManualReview,
      errorMessage);

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      __$$RecognitionResultImplCopyWithImpl<_$RecognitionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecognitionResultImplToJson(
      this,
    );
  }
}

abstract class _RecognitionResult implements RecognitionResult {
  const factory _RecognitionResult(
      {required final String imagePath,
      required final List<FoodItem> detectedItems,
      required final double overallConfidence,
      required final DateTime timestamp,
      final bool requiresManualReview,
      final String? errorMessage}) = _$RecognitionResultImpl;

  factory _RecognitionResult.fromJson(Map<String, dynamic> json) =
      _$RecognitionResultImpl.fromJson;

  @override
  String get imagePath;
  @override
  List<FoodItem> get detectedItems;
  @override
  double get overallConfidence;
  @override
  DateTime get timestamp;
  @override
  bool get requiresManualReview;
  @override
  String? get errorMessage;

  /// Create a copy of RecognitionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecognitionResultImplCopyWith<_$RecognitionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
