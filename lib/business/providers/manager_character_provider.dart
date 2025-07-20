import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/manager_character.dart';

final managerCharacterProvider = StateNotifierProvider<ManagerCharacterNotifier, ManagerCharacter?>((ref) {
  return ManagerCharacterNotifier();
});

class ManagerCharacterNotifier extends StateNotifier<ManagerCharacter?> {
  static const String _storageKey = 'manager_character';
  
  ManagerCharacterNotifier() : super(null) {
    loadCharacter();
  }

  Future<void> loadCharacter() async {
    // 常ににゃんこを返す
    state = const ManagerCharacter(
      type: CharacterType.cat,
      name: 'にゃんこ',
      imagePath: 'assets/images/cat.png',
      notificationLevel: NotificationLevel.normal,
      notificationsEnabled: true,
      reminderHours: [8, 12, 18],
    );
  }

  Future<void> setCharacter(ManagerCharacter character) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(character.toJson()));
    state = character;
  }

  Future<void> updateNotificationLevel(NotificationLevel level) async {
    if (state != null) {
      final updatedCharacter = state!.copyWith(notificationLevel: level);
      await setCharacter(updatedCharacter);
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (state != null) {
      final updatedCharacter = state!.copyWith(notificationsEnabled: enabled);
      await setCharacter(updatedCharacter);
    }
  }

  Future<void> updateReminderHours(List<int> hours) async {
    if (state != null) {
      final updatedCharacter = state!.copyWith(reminderHours: hours);
      await setCharacter(updatedCharacter);
    }
  }

  Future<void> clearCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = null;
  }
}