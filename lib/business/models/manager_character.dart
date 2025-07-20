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
        '食事の記録を忘れずに。目標達成への第一歩です！',
        'お時間があるときに食事を記録してくださいね。',
      ],
      NotificationLevel.normal: [
        '記録を続けることが成功の秘訣です！忘れずに入力しましょう。',
        '食事の記録、お忘れじゃないですか？一緒に頑張りましょう！',
        'そろそろ食事の記録をしましょう！目標まであと少し！',
      ],
      NotificationLevel.persistent: [
        '食事の記録がまだです！今日も目標に向かって頑張りましょう！',
        '記録することで意識が変わります！今すぐ入力しましょう！',
        '大事な食事記録を忘れています！継続は力なりですよ！',
      ],
    },
    CharacterType.cat: {
      NotificationLevel.gentle: [
        'にゃん〜 ごはんの記録、忘れてないかにゃ？',
        'にゃ〜ん、記録すると目標に近づくにゃ〜',
        'ゆっくりでいいから記録してにゃ〜 応援してるにゃ！',
      ],
      NotificationLevel.normal: [
        'にゃにゃ！まだ記録してないにゃ！一緒に頑張るにゃ〜',
        'にゃー！ごはんの記録で健康になるにゃ〜',
        'そろそろ記録するにゃ〜！今日も頑張ってるにゃ！',
      ],
      NotificationLevel.persistent: [
        'にゃにゃにゃ！！記録は成功への近道にゃ！！',
        'にゃー！！記録を続けて理想の体型になるにゃー！！',
        'すぐに記録するにゃ！！目標達成を応援してるにゃー！！',
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