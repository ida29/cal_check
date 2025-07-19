// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManagerCharacterImpl _$$ManagerCharacterImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerCharacterImpl(
      type: $enumDecode(_$CharacterTypeEnumMap, json['type']),
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      notificationLevel:
          $enumDecode(_$NotificationLevelEnumMap, json['notificationLevel']),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      reminderHours: (json['reminderHours'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [8, 12, 18],
    );

Map<String, dynamic> _$$ManagerCharacterImplToJson(
        _$ManagerCharacterImpl instance) =>
    <String, dynamic>{
      'type': _$CharacterTypeEnumMap[instance.type]!,
      'name': instance.name,
      'imagePath': instance.imagePath,
      'notificationLevel':
          _$NotificationLevelEnumMap[instance.notificationLevel]!,
      'notificationsEnabled': instance.notificationsEnabled,
      'reminderHours': instance.reminderHours,
    };

const _$CharacterTypeEnumMap = {
  CharacterType.human: 'human',
  CharacterType.cat: 'cat',
};

const _$NotificationLevelEnumMap = {
  NotificationLevel.gentle: 'gentle',
  NotificationLevel.normal: 'normal',
  NotificationLevel.persistent: 'persistent',
};
