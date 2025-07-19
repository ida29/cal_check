import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../business/models/manager_character.dart';
import '../../business/providers/manager_character_provider.dart';
import 'notification_settings_screen.dart';

class ManagerCharacterSetupScreen extends ConsumerStatefulWidget {
  const ManagerCharacterSetupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ManagerCharacterSetupScreen> createState() => _ManagerCharacterSetupScreenState();
}

class _ManagerCharacterSetupScreenState extends ConsumerState<ManagerCharacterSetupScreen> {
  CharacterType? _selectedCharacter;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'マネージャーを選ぼう！',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[400],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'あなたの食事記録をサポートする\nマネージャーを選んでください',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCharacterCard(
                    context,
                    CharacterType.human,
                    'さくら',
                    'あなたの健康を優しくサポートします！',
                    Icons.person_outline,
                    Colors.pink[300]!,
                  ),
                  _buildCharacterCard(
                    context,
                    CharacterType.cat,
                    'にゃんこ',
                    'にゃんにゃん記録を応援するにゃ！',
                    Icons.pets,
                    Colors.orange[300]!,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (_selectedCharacter != null) ...[
                _buildSampleMessage(),
                const SizedBox(height: 40),
              ],
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectedCharacter != null ? _onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: const Text(
                    '決定',
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

  Widget _buildCharacterCard(
    BuildContext context,
    CharacterType type,
    String name,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedCharacter == type;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCharacter = type;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: isSelected ? color : Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleMessage() {
    final message = ManagerCharacterMessages.getRandomMessage(
      _selectedCharacter!,
      NotificationLevel.normal, // デフォルトレベルでサンプル表示
    );
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            _selectedCharacter == CharacterType.human ? Icons.person : Icons.pets,
            color: _selectedCharacter == CharacterType.human ? Colors.pink[300] : Colors.orange[300],
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '通知メッセージの例',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (_selectedCharacter == null) return;
    
    // 通知設定画面へ遷移
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationSettingsScreen(
          selectedCharacter: _selectedCharacter!,
          isInitialSetup: ModalRoute.of(context)?.settings.arguments == 'initial_setup',
        ),
      ),
    );
  }
}