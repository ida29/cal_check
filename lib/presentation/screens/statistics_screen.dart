import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../l10n/app_localizations.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.statisticsTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPeriodSelector(),
              const SizedBox(height: 20),
              _buildCalorieChart(),
              const SizedBox(height: 20),
              _buildNutritionOverview(),
              const SizedBox(height: 20),
              _buildWeeklyGoals(),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildPeriodButton(AppLocalizations.of(context)!.week, 0),
          ),
          Expanded(
            child: _buildPeriodButton(AppLocalizations.of(context)!.month, 1),
          ),
          Expanded(
            child: _buildPeriodButton(AppLocalizations.of(context)!.year, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String text, int index) {
    final isSelected = _selectedPeriod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCalorieChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.calorieIntakeTrend,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            AppLocalizations.of(context)!.monday,
                            AppLocalizations.of(context)!.tuesday,
                            AppLocalizations.of(context)!.wednesday,
                            AppLocalizations.of(context)!.thursday,
                            AppLocalizations.of(context)!.friday,
                            AppLocalizations.of(context)!.saturday,
                            AppLocalizations.of(context)!.sunday,
                          ];
                          if (value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1800),
                        FlSpot(1, 2100),
                        FlSpot(2, 1950),
                        FlSpot(3, 2200),
                        FlSpot(4, 1900),
                        FlSpot(5, 2000),
                        FlSpot(6, 1770),
                      ],
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 6,
                  minY: 1500,
                  maxY: 2500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(AppLocalizations.of(context)!.average, '1,960 cal'),
                _buildStatItem(AppLocalizations.of(context)!.lowest, '1,770 cal'),
                _buildStatItem(AppLocalizations.of(context)!.highest, '2,200 cal'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.nutritionBreakdown,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.blue,
                            value: 45,
                            title: AppLocalizations.of(context)!.carbsPercentage,
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: 30,
                            title: AppLocalizations.of(context)!.fatPercentage,
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: 25,
                            title: AppLocalizations.of(context)!.proteinPercentage,
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildNutritionItem(AppLocalizations.of(context)!.carbohydrates, '220g', '45%', Colors.blue),
                      _buildNutritionItem(AppLocalizations.of(context)!.protein, '120g', '25%', Colors.green),
                      _buildNutritionItem(AppLocalizations.of(context)!.fat, '65g', '30%', Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String name, String amount, String percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 14)),
          ),
          Text('$amount ($percentage)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoals() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weeklyGoalsProgress,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildGoalProgress(AppLocalizations.of(context)!.calorieGoal, 0.88, '12,320 / 14,000 cal'),
            const SizedBox(height: 16),
            _buildGoalProgress(AppLocalizations.of(context)!.exerciseGoal, 0.60, '3 / 5 workouts'),
            const SizedBox(height: 16),
            _buildGoalProgress(AppLocalizations.of(context)!.waterIntake, 0.75, '15 / 20 glasses'),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgress(String title, double progress, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 0.8 ? Colors.green : Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}