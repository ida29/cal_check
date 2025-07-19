import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/food_database.dart';
import '../models/manager_character.dart';
import '../providers/manager_character_provider.dart';
import 'notification_service.dart';

class MealReminderService {
  static const Duration _checkInterval = Duration(minutes: 30);
  static DateTime? _lastNotificationTime;
  
  static Future<int> getMissedMealCount() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // 今日の食事記録を取得
    final database = FoodDatabase();
    final todayMeals = await database.getMealsByDateRange(today, today.add(const Duration(days: 1)));
    
    // 現在の時刻から判断して、何回分の食事を記録すべきか計算
    int expectedMeals = 0;
    if (now.hour >= 7) expectedMeals++; // 朝食
    if (now.hour >= 12) expectedMeals++; // 昼食
    if (now.hour >= 18) expectedMeals++; // 夕食
    
    // 実際に記録された食事の数
    final recordedMeals = todayMeals.length;
    
    // 未記録の食事数
    return (expectedMeals - recordedMeals).clamp(0, 3);
  }
  
  static Future<void> checkAndNotify(ManagerCharacter character) async {
    if (!character.notificationsEnabled) return;
    
    final missedCount = await getMissedMealCount();
    if (missedCount == 0) return;
    
    // 最後の通知から一定時間経過していない場合は通知しない
    if (_lastNotificationTime != null) {
      final timeSinceLastNotification = DateTime.now().difference(_lastNotificationTime!);
      final minInterval = _getMinimumInterval(character.notificationLevel);
      
      if (timeSinceLastNotification < minInterval) return;
    }
    
    // 通知を送信
    final title = _getNotificationTitle(character);
    final body = ManagerCharacterMessages.getRandomMessage(
      character.type,
      character.notificationLevel,
    );
    
    await NotificationService.showInstantNotification(
      title: title,
      body: body,
    );
    
    _lastNotificationTime = DateTime.now();
  }
  
  static Duration _getMinimumInterval(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.gentle:
        return const Duration(hours: 3);
      case NotificationLevel.normal:
        return const Duration(hours: 1);
      case NotificationLevel.persistent:
        return const Duration(minutes: 30);
    }
  }
  
  static String _getNotificationTitle(ManagerCharacter character) {
    if (character.type == CharacterType.human) {
      return '${character.name}からのリマインダー';
    } else {
      return '${character.name}からのお知らせにゃ';
    }
  }
}

final mealReminderServiceProvider = Provider((ref) {
  return MealReminderService();
});

// 定期的にチェックするためのタイマープロバイダー
final mealReminderTimerProvider = StreamProvider.autoDispose<void>((ref) async* {
  final character = ref.watch(managerCharacterProvider);
  if (character == null || !character.notificationsEnabled) return;
  
  while (true) {
    await Future.delayed(MealReminderService._checkInterval);
    await MealReminderService.checkAndNotify(character);
    yield null;
  }
});