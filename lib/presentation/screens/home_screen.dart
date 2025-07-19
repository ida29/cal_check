import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

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
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 手動入力ボタン
          Container(
            height: 56,
            width: 56,
            margin: const EdgeInsets.only(right: 12),
            child: FloatingActionButton(
              heroTag: "manual_input",
              onPressed: () {
                Navigator.pushNamed(context, '/manual-meal-entry');
              },
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              elevation: 4,
              child: const Icon(
                Icons.edit_rounded,
                size: 24,
              ),
            ),
          ),
          // カメラボタン
          Container(
            height: 70,
            width: 70,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "camera",
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                },
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
                elevation: 8,
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
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

  Widget _buildQuickActionsSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: Color(0xFFFF69B4), size: 24),
            const SizedBox(width: 8),
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.fitness_center_rounded,
                title: l10n.recordExercise,
                subtitle: l10n.recordExerciseSubtitle,
                color: const Color(0xFF4CAF50),
                onTap: () {
                  Navigator.pushNamed(context, '/exercise');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.restaurant_menu_rounded,
                title: l10n.mealHistoryAction,
                subtitle: l10n.checkTodaysMeals,
                color: const Color(0xFF2196F3),
                onTap: () {
                  // 履歴画面へ移動（BottomNavigationを切り替える）
                  final scaffold = context.findAncestorStateOfType<State<Scaffold>>();
                  if (scaffold != null && scaffold.mounted) {
                    // MainNavigationScreenの_currentIndexを変更
                    Navigator.of(context).pushReplacementNamed('/main', arguments: 1);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.water_drop_rounded,
                title: l10n.recordWater,
                subtitle: l10n.recordWaterSubtitle,
                color: const Color(0xFF00BCD4),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.waterRecordingComingSoon)),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Icons.insights_rounded,
                title: l10n.statisticsAction,
                subtitle: l10n.checkProgress,
                color: const Color(0xFFFF9800),
                onTap: () {
                  // 統計画面へ移動
                  Navigator.of(context).pushReplacementNamed('/main', arguments: 3);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

}