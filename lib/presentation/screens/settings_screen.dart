import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/locale_provider.dart';
import '../../business/providers/manager_character_provider.dart';
import '../../business/providers/user_provider.dart';
import '../../data/entities/user.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  ActivityLevel? _selectedActivityLevel;
  
  // Controllers for profile dialog
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
        children: [
          _buildUserProfileSection(),
          const Divider(),
          _buildGoalsSection(),
          const Divider(),
          _buildNotificationSection(),
          const Divider(),
          _buildAppPreferencesSection(l10n, currentLocale),
          const Divider(),
          _buildAboutSection(),
        ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.userProfile,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(l10n.personalInformation),
          subtitle: Text(l10n.updateProfileDetails),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showPersonalInfoDialog();
          },
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.goalsTargets,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.local_fire_department),
          title: Text(l10n.dailyCalorieGoal),
          subtitle: Text(l10n.caloriesAmount),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showCalorieGoalDialog();
          },
        ),
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: Text(l10n.activityLevel),
          subtitle: Text(l10n.moderatelyActive),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showActivityLevelDialog();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    final l10n = AppLocalizations.of(context)!;
    final managerCharacter = ref.watch(managerCharacterProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.notifications,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.pets,
            color: Colors.orange[300],
          ),
          title: const Text('マネージャー'),
          subtitle: const Text('にゃんこ'),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: Text(l10n.mealReminders),
          subtitle: Text(l10n.mealReminderDescription),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(l10n.reminderTimes),
          subtitle: Text(l10n.defaultReminderTimes),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showReminderTimesDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection(AppLocalizations l10n, Locale currentLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.appPreferences,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF69B4).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.language_rounded, color: Color(0xFFFF69B4)),
          ),
          title: Text(l10n.language),
          subtitle: Text(currentLocale.languageCode == 'ja' ? l10n.japanese : l10n.english),
          trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF69B4)),
          onTap: () {
            _showLanguageDialog();
          },
        ),
        ListTile(
          leading: const Icon(Icons.straighten),
          title: Text(l10n.units),
          subtitle: Text(l10n.metricUnits),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showUnitsDialog();
          },
        ),
      ],
    );
  }


  Widget _buildAboutSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            l10n.about,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: Text(l10n.version),
          subtitle: Text(l10n.versionNumber),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: Text(l10n.privacyPolicy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushNamed(context, '/privacy-policy');
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: Text(l10n.helpSupport),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.helpSupportComingSoon)),
            );
          },
        ),
      ],
    );
  }

  void _showPersonalInfoDialog() async {
    final l10n = AppLocalizations.of(context)!;
    
    // Load existing user data
    final userAsync = ref.read(userProvider);
    await userAsync.when(
      data: (user) async {
        if (user != null) {
          _nameController.text = user.name ?? '';
          _ageController.text = user.age?.toString() ?? '';
          _heightController.text = user.height?.toString() ?? '';
          _weightController.text = user.weight?.toString() ?? '';
        }
      },
      loading: () async {},
      error: (error, stack) async {},
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF69B4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFFFF69B4),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.personalInformation),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.name,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: l10n.age,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: l10n.heightCm,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: l10n.weight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _savePersonalInfo();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF69B4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showCalorieGoalDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyCalorieGoalTitle),
        content: TextField(
          decoration: InputDecoration(
            labelText: l10n.caloriesPerDay,
            suffixText: l10n.calUnit,
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.calorieGoalUpdated)),
              );
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showActivityLevelDialog() {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.read(userProvider);
    
    // Get current activity level from user data
    ActivityLevel? currentActivityLevel;
    userAsync.whenData((user) {
      if (user != null) {
        currentActivityLevel = user.activityLevel;
        _selectedActivityLevel = user.activityLevel;
      }
    });
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF69B4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: Color(0xFFFF69B4),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(l10n.activityLevelTitle),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ActivityLevel.values.map((activityLevel) {
                String levelText;
                String description;
                
                switch (activityLevel) {
                  case ActivityLevel.sedentary:
                    levelText = l10n.sedentary;
                    description = 'デスクワーク中心、運動なし';
                    break;
                  case ActivityLevel.lightlyActive:
                    levelText = l10n.lightlyActive;
                    description = '軽い運動、週1-3回';
                    break;
                  case ActivityLevel.moderatelyActive:
                    levelText = l10n.moderatelyActive;
                    description = '中程度の運動、週3-5回';
                    break;
                  case ActivityLevel.veryActive:
                    levelText = l10n.veryActive;
                    description = '激しい運動、週6-7回';
                    break;
                  case ActivityLevel.extraActive:
                    levelText = l10n.extraActive;
                    description = '非常に激しい運動、1日2回';
                    break;
                }
                
                return RadioListTile<ActivityLevel>(
                  title: Text(
                    levelText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  value: activityLevel,
                  groupValue: _selectedActivityLevel,
                  activeColor: const Color(0xFFFF69B4),
                  onChanged: (ActivityLevel? value) {
                    setDialogState(() {
                      _selectedActivityLevel = value;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedActivityLevel != null ? () async {
                Navigator.pop(context);
                await _saveActivityLevel(_selectedActivityLevel!);
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveActivityLevel(ActivityLevel activityLevel) async {
    try {
      final userAsync = ref.read(userProvider);
      await userAsync.when(
        data: (user) async {
          if (user != null) {
            final updatedUser = user.copyWith(
              activityLevel: activityLevel,
              updatedAt: DateTime.now(),
            );
            await ref.read(userProvider.notifier).updateUser(updatedUser);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.activityLevelUpdated),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        loading: () async {},
        error: (error, stack) async {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('エラーが発生しました: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showLanguageDialog() {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.read(localeProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF69B4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.language_rounded, color: Color(0xFFFF69B4)),
            ),
            const SizedBox(width: 12),
            Text(l10n.language),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(l10n.englishLanguage, 'en', currentLocale),
            _buildLanguageOption(l10n.japaneseLanguage, 'ja', currentLocale),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String title, String languageCode, Locale currentLocale) {
    final isSelected = currentLocale.languageCode == languageCode;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF69B4).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: const Color(0xFFFF69B4), width: 2) : null,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFFFF69B4) : null,
          ),
        ),
        trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFFFF69B4)) : null,
        onTap: () {
          ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showUnitsDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unitsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text(l10n.metricUnitsOption),
              value: 'metric',
              groupValue: 'metric',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: Text(l10n.imperialUnits),
              value: 'imperial',
              groupValue: 'metric',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }


  void _showReminderTimesDialog() {
    final selectedHours = [8, 12, 18]; // デフォルトのリマインダー時間
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('リマインダー時間'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('通知を受け取る時間を選択してください'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(24, (hour) {
                  final isSelected = selectedHours.contains(hour);
                  return FilterChip(
                    label: Text('$hour:00'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setDialogState(() {
                        if (selected) {
                          selectedHours.add(hour);
                        } else {
                          selectedHours.remove(hour);
                        }
                        selectedHours.sort();
                      });
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                // TODO: リマインダー時間を保存
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _savePersonalInfo() async {
    try {
      final age = int.tryParse(_ageController.text);
      final height = double.tryParse(_heightController.text);
      final weight = double.tryParse(_weightController.text);
      final name = _nameController.text.trim();
      
      if (name.isEmpty || age == null || height == null || weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('すべての項目を正しく入力してください'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (age <= 0 || height <= 0 || weight <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('有効な数値を入力してください'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final userAsync = ref.read(userProvider);
      await userAsync.when(
        data: (user) async {
          if (user != null) {
            final updatedUser = user.copyWith(
              name: name,
              age: age,
              height: height,
              weight: weight,
              updatedAt: DateTime.now(),
            );
            await ref.read(userProvider.notifier).updateUser(updatedUser);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.profileUpdated),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            // Create new user if none exists
            final newUser = User(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: name,
              age: age,
              height: height,
              weight: weight,
              gender: Gender.other, // Default value
              activityLevel: ActivityLevel.moderatelyActive, // Default value
              targetCalories: 2000.0, // Default value
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await ref.read(userProvider.notifier).saveUser(newUser);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('プロフィールを作成しました'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        loading: () async {},
        error: (error, stack) async {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('エラーが発生しました: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

}