import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDailySummaryCard(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              Expanded(
                child: _buildRecentMeals(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToScreen(index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF69B4),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: l10n.homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history_rounded),
            label: l10n.historyTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics_rounded),
            label: l10n.statisticsTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.settingsTitle,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        label: Text(l10n.takePicture),
        icon: const Icon(Icons.camera_alt_rounded),
        backgroundColor: const Color(0xFFFF69B4),
        foregroundColor: Colors.white,
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
                      '62% of daily goal',
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

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.restaurant_menu_rounded,
            label: 'Meal Ideas',
            color: const Color(0xFFFFB347),
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            icon: Icons.water_drop_rounded,
            label: 'Water Intake',
            color: const Color(0xFF87CEEB),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMeals() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history_rounded, color: Color(0xFFFF69B4), size: 24),
            const SizedBox(width: 8),
            Text(
              'Recent Meals',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildMealCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMealCard(int index) {
    final l10n = AppLocalizations.of(context)!;
    final meals = [l10n.breakfast, l10n.lunch, l10n.dinner];
    final calories = ['320', '580', '345'];
    final times = ['8:30 AM', '12:45 PM', '6:30 PM'];
    final colors = [
      const Color(0xFFFFB347), // オレンジ
      const Color(0xFF98FB98), // ライトグリーン
      const Color(0xFFDDA0DD), // プラム
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [colors[index].withOpacity(0.1), colors[index].withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors[index].withOpacity(0.8), colors[index]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.restaurant_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            meals[index],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors[index],
            ),
          ),
          subtitle: Text(
            times[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors[index].withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${calories[index]} cal',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: colors[index],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        Navigator.pushNamed(context, '/statistics');
        break;
      case 3:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }
}