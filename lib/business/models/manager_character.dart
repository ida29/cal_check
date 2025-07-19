import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_character.freezed.dart';
part 'manager_character.g.dart';

enum CharacterType { human, cat }

enum NotificationLevel { gentle, normal, persistent }

@freezed
class ManagerCharacter with _$ManagerCharacter {
  const factory ManagerCharacter({
    required CharacterType type,
    required String name,
    required String imagePath,
    required NotificationLevel notificationLevel,
    @Default(true) bool notificationsEnabled,
    @Default([8, 12, 18]) List<int> reminderHours,
  }) = _ManagerCharacter;

  factory ManagerCharacter.fromJson(Map<String, dynamic> json) =>
      _$ManagerCharacterFromJson(json);
}

class ManagerCharacterMessages {
  static Map<CharacterType, Map<NotificationLevel, List<String>>> messages = {
    CharacterType.human: {
      NotificationLevel.gentle: [
        'こんにちは！今日の食事はもう記録しましたか？',
        '食事の記録を忘れずにお願いしますね。',
        'お時間があるときに食事を記録してください。',
      ],
      NotificationLevel.normal: [
        'まだ食事を記録していませんね。忘れずに入力してください！',
        '食事の記録、お忘れじゃないですか？',
        'そろそろ食事の記録をしましょう！',
      ],
      NotificationLevel.persistent: [
        '食事の記録がまだです！今すぐ入力してください！',
        'もう食事の時間が過ぎています！記録してください！',
        '大事な食事記録を忘れています！すぐに入力しましょう！',
      ],
    },
    CharacterType.cat: {
      NotificationLevel.gentle: [
        'にゃん〜 ごはんの記録、忘れてないかにゃ？',
        'にゃ〜ん、記録するの忘れずにね〜',
        'ゆっくりでいいから記録してにゃ〜',
      ],
      NotificationLevel.normal: [
        'にゃにゃ！？まだ記録してないにゃ！',
        'にゃー！ごはんの記録忘れてるにゃ〜',
        'そろそろ記録するにゃ〜！',
      ],
      NotificationLevel.persistent: [
        'にゃにゃにゃ！！まだ記録してないにゃ！！',
        'にゃー！！大変にゃ！記録忘れてるにゃー！！',
        'すぐに記録するにゃ！！待ってるにゃー！！',
      ],
    },
  };

  static String getRandomMessage(CharacterType type, NotificationLevel level) {
    final messageList = messages[type]?[level] ?? [];
    if (messageList.isEmpty) return '食事の記録をお忘れなく！';
    
    final randomIndex = DateTime.now().millisecondsSinceEpoch % messageList.length;
    return messageList[randomIndex];
  }
}