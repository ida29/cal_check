import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/manager_character_provider.dart';
import '../../business/models/manager_character.dart';
import '../../business/services/meal_reminder_service.dart';
import 'manager_character_setup_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    // 食事リマインダータイマーを開始
    ref.read(mealReminderTimerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotificationPanel();
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: FutureBuilder<int>(
                  future: _getUnreadNotificationCount(),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 9 ? '9+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildManagerCharacterSection(),
              const SizedBox(height: 16),
              _buildDailySummaryCard(),
              const SizedBox(height: 20),
              _buildMainActionButton(),
              const SizedBox(height: 16),
              _buildFoodRecordButton(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummaryCard() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.today_rounded, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    l10n.todayTotal,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(l10n.calories, '1,245', '2,000'),
                    _buildSummaryItem(l10n.protein, '45g', '60g'),
                    _buildSummaryItem(l10n.carbs, '180g', '250g'),
                    _buildSummaryItem(l10n.fat, '40g', '65g'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: 0.62,
                      backgroundColor: Colors.pink[100],
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF69B4)),
                      minHeight: 8,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '62${l10n.dailyGoalProgress}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFFF69B4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, String target) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        Text(
          '/ $target',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildManagerCharacterSection() {
    final managerCharacter = ref.watch(managerCharacterProvider);
    
    if (managerCharacter == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerCharacterSetupScreen(),
                settings: const RouteSettings(arguments: 'initial_setup'),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'マネージャーを設定しよう！',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '食事記録をサポートしてくれます',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
    
    return FutureBuilder<int>(
      future: MealReminderService.getMissedMealCount(),
      builder: (context, snapshot) {
        final missedCount = snapshot.data ?? 0;
        final message = missedCount > 0
            ? ManagerCharacterMessages.getRandomMessage(
                managerCharacter.type,
                NotificationLevel.gentle,
              )
            : _getEncouragementMessage(managerCharacter.type);
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: managerCharacter.type == CharacterType.human
                        ? Colors.pink[100]
                        : Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    managerCharacter.type == CharacterType.human
                        ? Icons.person
                        : Icons.pets,
                    size: 35,
                    color: managerCharacter.type == CharacterType.human
                        ? Colors.pink[300]
                        : Colors.orange[300],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            managerCharacter.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (missedCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '未記録: $missedCount',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  String _getEncouragementMessage(CharacterType type) {
    if (type == CharacterType.human) {
      return '順調に記録できていますね！その調子です！';
    } else {
      return 'よく頑張ってるにゃ〜！えらいにゃ〜！';
    }
  }

  Widget _buildMainActionButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF69B4),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_rounded,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              '写真で食事を記録',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodRecordButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF87CEEB), Color(0xFF4169E1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/manual-meal-entry');
            },
            borderRadius: BorderRadius.circular(20),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '食べ物から記録を追加',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '食べ物を検索して手動で記録',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<int> _getUnreadNotificationCount() async {
    // TODO: 実際の未読通知数を取得する実装
    // 今は仮の値を返す
    final managerCharacter = ref.read(managerCharacterProvider);
    if (managerCharacter == null) return 0;
    
    final missedMeals = await MealReminderService.getMissedMealCount();
    return missedMeals;
  }

  void _showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationPanel(),
    );
  }
}

class NotificationPanel extends ConsumerWidget {
  const NotificationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerCharacter = ref.watch(managerCharacterProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '通知',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: すべて既読にする
                  },
                  child: const Text('すべて既読'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: _getNotifications(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final notifications = snapshot.data ?? [];
                
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '新しい通知はありません',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationTile(context, notification, managerCharacter);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationTile(BuildContext context, NotificationItem notification, ManagerCharacter? manager) {
    IconData icon;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.mealReminder:
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case NotificationType.achievement:
        icon = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
      case NotificationType.tip:
        icon = Icons.lightbulb_outline;
        iconColor = Colors.blue;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // TODO: 通知を既読にする
        },
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else {
      return '${difference.inDays}日前';
    }
  }
  
  Future<List<NotificationItem>> _getNotifications(WidgetRef ref) async {
    final notifications = <NotificationItem>[];
    final managerCharacter = ref.read(managerCharacterProvider);
    
    // 食事記録リマインダー
    final missedMeals = await MealReminderService.getMissedMealCount();
    if (missedMeals > 0) {
      final message = managerCharacter != null
          ? ManagerCharacterMessages.getRandomMessage(
              managerCharacter.type,
              managerCharacter.notificationLevel,
            )
          : '食事の記録を忘れていませんか？';
          
      notifications.add(NotificationItem(
        id: 'meal_reminder',
        type: NotificationType.mealReminder,
        title: '食事記録のリマインダー',
        message: message,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ));
    }
    
    // TODO: 他の通知を追加（実績、ヒントなど）
    
    return notifications;
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  
  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });
}

enum NotificationType {
  mealReminder,
  achievement,
  tip,
}