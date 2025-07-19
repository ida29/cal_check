import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/manager_character.dart';
import '../providers/manager_character_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(android: android, iOS: ios);
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _isInitialized = true;
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // 通知タップ時の処理
    // TODO: アプリを開いて食事入力画面に遷移
  }

  static Future<void> requestPermissions() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> scheduleReminders(ManagerCharacter character) async {
    if (!character.notificationsEnabled) return;
    
    // 既存の通知をキャンセル
    await cancelAllNotifications();
    
    // 各リマインダー時間に通知をスケジュール
    for (int i = 0; i < character.reminderHours.length; i++) {
      final hour = character.reminderHours[i];
      await _scheduleDaily(
        id: i,
        hour: hour,
        title: _getNotificationTitle(character),
        body: ManagerCharacterMessages.getRandomMessage(
          character.type,
          character.notificationLevel,
        ),
      );
    }
  }

  static String _getNotificationTitle(ManagerCharacter character) {
    if (character.type == CharacterType.human) {
      return '${character.name}からのメッセージ';
    } else {
      return '${character.name}からのお知らせにゃ';
    }
  }

  static Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );
    
    // 既に過ぎている時間の場合は翌日に設定
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'meal_reminder',
      '食事リマインダー',
      channelDescription: '食事の記録を忘れないようにお知らせします',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant_notification',
      '即時通知',
      channelDescription: '重要なお知らせを表示します',
      importance: Importance.max,
      priority: Priority.max,
      showWhen: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<void> updateBadgeCount(int count) async {
    // iOS only
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    // Note: iOS badge updates require additional native code implementation
  }
}

final notificationServiceProvider = Provider((ref) {
  // マネージャーキャラクターの変更を監視
  ref.listen(managerCharacterProvider, (previous, next) {
    if (next != null) {
      NotificationService.scheduleReminders(next);
    }
  });
  
  return NotificationService();
});