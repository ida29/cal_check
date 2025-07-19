import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.reminderTimesComingSoon)),
            );
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.privacyPolicyComingSoon)),
            );
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

  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.personalInformation),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: l10n.name),
            ),
            TextField(
              decoration: InputDecoration(labelText: l10n.age),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: l10n.heightCm),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: l10n.weight),
              keyboardType: TextInputType.number,
            ),
          ],
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
                SnackBar(content: Text(l10n.profileUpdated)),
              );
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  void _showCalorieGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyCalorieGoalTitle),
        content: const TextField(
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.activityLevelTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            l10n.sedentary,
            l10n.lightlyActive,
            l10n.moderatelyActive,
            l10n.veryActive,
            l10n.extraActive
          ].map((level) => RadioListTile(
                title: Text(level),
                value: level,
                groupValue: l10n.moderatelyActive,
                onChanged: (value) {},
              )).toList(),
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
                SnackBar(content: Text(l10n.activityLevelUpdated)),
              );
            },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
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

}