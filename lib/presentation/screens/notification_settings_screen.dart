import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../business/models/manager_character.dart';
import '../../business/providers/manager_character_provider.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  final CharacterType selectedCharacter;
  final bool isInitialSetup;
  
  const NotificationSettingsScreen({
    Key? key,
    required this.selectedCharacter,
    required this.isInitialSetup,
  }) : super(key: key);

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  NotificationLevel _notificationLevel = NotificationLevel.normal;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.pink[400]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                '通知の頻度を設定',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[400],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.selectedCharacter == CharacterType.human ? 'さくら' : 'にゃんこ'}からの\n通知の頻度を選んでください',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              
              Text(
                '通知の頻度',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildNotificationLevelSelector(),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    '設定完了',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationLevelSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: NotificationLevel.values.map((level) {
          final isSelected = _notificationLevel == level;
          final levelInfo = _getLevelInfo(level);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _notificationLevel = level;
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? levelInfo.color : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    levelInfo.icon,
                    color: isSelected ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          levelInfo.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          levelInfo.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  _LevelInfo _getLevelInfo(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.gentle:
        return _LevelInfo(
          '控えめ', 
          Icons.volume_down, 
          Colors.green[400]!,
          '必要最小限の通知のみ'
        );
      case NotificationLevel.normal:
        return _LevelInfo(
          '標準', 
          Icons.notifications, 
          Colors.blue[400]!,
          '適度な頻度で通知'
        );
      case NotificationLevel.persistent:
        return _LevelInfo(
          'しっかり', 
          Icons.notification_important, 
          Colors.orange[400]!,
          'こまめに通知でサポート'
        );
    }
  }

  void _onConfirm() {
    final character = ManagerCharacter(
      type: widget.selectedCharacter,
      name: widget.selectedCharacter == CharacterType.human ? 'さくら' : 'にゃんこ',
      imagePath: '', // 後で実際の画像パスを設定
      notificationLevel: _notificationLevel,
    );
    
    ref.read(managerCharacterProvider.notifier).setCharacter(character);
    
    // 初回設定の場合はメイン画面へ、設定変更の場合は2つ前の画面へ戻る
    if (widget.isInitialSetup) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      // マネージャー選択画面とこの画面の2つを閉じて設定画面に戻る
      Navigator.pop(context); // 通知設定画面を閉じる
      Navigator.pop(context); // マネージャー選択画面を閉じる
    }
  }
}

class _LevelInfo {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  
  _LevelInfo(this.name, this.icon, this.color, this.description);
}