// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manager_character.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ManagerCharacter _$ManagerCharacterFromJson(Map<String, dynamic> json) {
  return _ManagerCharacter.fromJson(json);
}

/// @nodoc
mixin _$ManagerCharacter {
  CharacterType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  NotificationLevel get notificationLevel => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  List<int> get reminderHours => throw _privateConstructorUsedError;

  /// Serializes this ManagerCharacter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ManagerCharacter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManagerCharacterCopyWith<ManagerCharacter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManagerCharacterCopyWith<$Res> {
  factory $ManagerCharacterCopyWith(
          ManagerCharacter value, $Res Function(ManagerCharacter) then) =
      _$ManagerCharacterCopyWithImpl<$Res, ManagerCharacter>;
  @useResult
  $Res call(
      {CharacterType type,
      String name,
      String imagePath,
      NotificationLevel notificationLevel,
      bool notificationsEnabled,
      List<int> reminderHours});
}

/// @nodoc
class _$ManagerCharacterCopyWithImpl<$Res, $Val extends ManagerCharacter>
    implements $ManagerCharacterCopyWith<$Res> {
  _$ManagerCharacterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ManagerCharacter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? imagePath = null,
    Object? notificationLevel = null,
    Object? notificationsEnabled = null,
    Object? reminderHours = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CharacterType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      notificationLevel: null == notificationLevel
          ? _value.notificationLevel
          : notificationLevel // ignore: cast_nullable_to_non_nullable
              as NotificationLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderHours: null == reminderHours
          ? _value.reminderHours
          : reminderHours // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManagerCharacterImplCopyWith<$Res>
    implements $ManagerCharacterCopyWith<$Res> {
  factory _$$ManagerCharacterImplCopyWith(_$ManagerCharacterImpl value,
          $Res Function(_$ManagerCharacterImpl) then) =
      __$$ManagerCharacterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CharacterType type,
      String name,
      String imagePath,
      NotificationLevel notificationLevel,
      bool notificationsEnabled,
      List<int> reminderHours});
}

/// @nodoc
class __$$ManagerCharacterImplCopyWithImpl<$Res>
    extends _$ManagerCharacterCopyWithImpl<$Res, _$ManagerCharacterImpl>
    implements _$$ManagerCharacterImplCopyWith<$Res> {
  __$$ManagerCharacterImplCopyWithImpl(_$ManagerCharacterImpl _value,
      $Res Function(_$ManagerCharacterImpl) _then)
      : super(_value, _then);

  /// Create a copy of ManagerCharacter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? name = null,
    Object? imagePath = null,
    Object? notificationLevel = null,
    Object? notificationsEnabled = null,
    Object? reminderHours = null,
  }) {
    return _then(_$ManagerCharacterImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CharacterType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      notificationLevel: null == notificationLevel
          ? _value.notificationLevel
          : notificationLevel // ignore: cast_nullable_to_non_nullable
              as NotificationLevel,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      reminderHours: null == reminderHours
          ? _value._reminderHours
          : reminderHours // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManagerCharacterImpl implements _ManagerCharacter {
  const _$ManagerCharacterImpl(
      {required this.type,
      required this.name,
      required this.imagePath,
      required this.notificationLevel,
      this.notificationsEnabled = true,
      final List<int> reminderHours = const [8, 12, 18]})
      : _reminderHours = reminderHours;

  factory _$ManagerCharacterImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManagerCharacterImplFromJson(json);

  @override
  final CharacterType type;
  @override
  final String name;
  @override
  final String imagePath;
  @override
  final NotificationLevel notificationLevel;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  final List<int> _reminderHours;
  @override
  @JsonKey()
  List<int> get reminderHours {
    if (_reminderHours is EqualUnmodifiableListView) return _reminderHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminderHours);
  }

  @override
  String toString() {
    return 'ManagerCharacter(type: $type, name: $name, imagePath: $imagePath, notificationLevel: $notificationLevel, notificationsEnabled: $notificationsEnabled, reminderHours: $reminderHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManagerCharacterImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.notificationLevel, notificationLevel) ||
                other.notificationLevel == notificationLevel) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            const DeepCollectionEquality()
                .equals(other._reminderHours, _reminderHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      name,
      imagePath,
      notificationLevel,
      notificationsEnabled,
      const DeepCollectionEquality().hash(_reminderHours));

  /// Create a copy of ManagerCharacter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManagerCharacterImplCopyWith<_$ManagerCharacterImpl> get copyWith =>
      __$$ManagerCharacterImplCopyWithImpl<_$ManagerCharacterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManagerCharacterImplToJson(
      this,
    );
  }
}

abstract class _ManagerCharacter implements ManagerCharacter {
  const factory _ManagerCharacter(
      {required final CharacterType type,
      required final String name,
      required final String imagePath,
      required final NotificationLevel notificationLevel,
      final bool notificationsEnabled,
      final List<int> reminderHours}) = _$ManagerCharacterImpl;

  factory _ManagerCharacter.fromJson(Map<String, dynamic> json) =
      _$ManagerCharacterImpl.fromJson;

  @override
  CharacterType get type;
  @override
  String get name;
  @override
  String get imagePath;
  @override
  NotificationLevel get notificationLevel;
  @override
  bool get notificationsEnabled;
  @override
  List<int> get reminderHours;

  /// Create a copy of ManagerCharacter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManagerCharacterImplCopyWith<_$ManagerCharacterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
