import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildUserProfileSection(),
          const Divider(),
          _buildGoalsSection(),
          const Divider(),
          _buildNotificationSection(),
          const Divider(),
          _buildAppPreferencesSection(),
          const Divider(),
          _buildDataSection(),
          const Divider(),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'User Profile',
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
          title: const Text('Personal Information'),
          subtitle: const Text('Update your profile details'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showPersonalInfoDialog();
          },
        ),
      ],
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Goals & Targets',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.local_fire_department),
          title: const Text('Daily Calorie Goal'),
          subtitle: const Text('2,000 calories'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showCalorieGoalDialog();
          },
        ),
        ListTile(
          leading: const Icon(Icons.fitness_center),
          title: const Text('Activity Level'),
          subtitle: const Text('Moderately Active'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showActivityLevelDialog();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications),
          title: const Text('Meal Reminders'),
          subtitle: const Text('Get notified for meal times'),
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: const Text('Reminder Times'),
          subtitle: const Text('Breakfast: 8:00 AM, Lunch: 12:00 PM, Dinner: 7:00 PM'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reminder times feature coming soon!')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAppPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'App Preferences',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: _darkModeEnabled,
          onChanged: (value) {
            setState(() {
              _darkModeEnabled = value;
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(_selectedLanguage),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showLanguageDialog();
          },
        ),
        ListTile(
          leading: const Icon(Icons.straighten),
          title: const Text('Units'),
          subtitle: const Text('Metric (kg, cm)'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showUnitsDialog();
          },
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Data Management',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.backup),
          title: const Text('Export Data'),
          subtitle: const Text('Export your meal history'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Export feature coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: const Text('Clear All Data'),
          subtitle: const Text('Delete all meals and settings'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            _showClearDataDialog();
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Version'),
          subtitle: const Text('1.0.0'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Privacy policy feature coming soon!')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.help),
          title: const Text('Help & Support'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help & support feature coming soon!')),
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
        title: const Text('Personal Information'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showCalorieGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily Calorie Goal'),
        content: const TextField(
          decoration: InputDecoration(
            labelText: 'Calories per day',
            suffixText: 'cal',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calorie goal updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showActivityLevelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Sedentary',
            'Lightly Active',
            'Moderately Active',
            'Very Active',
            'Extra Active'
          ].map((level) => RadioListTile(
                title: Text(level),
                value: level,
                groupValue: 'Moderately Active',
                onChanged: (value) {},
              )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity level updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German', 'Japanese']
              .map((language) => RadioListTile(
                    title: Text(language),
                    value: language,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showUnitsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Units'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Metric (kg, cm)'),
              value: 'metric',
              groupValue: 'metric',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: const Text('Imperial (lbs, ft)'),
              value: 'imperial',
              groupValue: 'metric',
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will permanently delete all your meal history and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data cleared successfully!')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}