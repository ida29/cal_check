import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/user_profile_provider.dart';
import '../../business/providers/meal_history_provider.dart';
import 'dart:math' as math;

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
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
              _buildHealthMetricsCard(),
              const SizedBox(height: 20),
              _buildCalorieChart(),
              const SizedBox(height: 20),
              _buildPFCBalanceCard(),
              const SizedBox(height: 20),
              _buildNutritionAssessment(),
              const SizedBox(height: 20),
              _buildWeightPrediction(),
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

  Widget _buildHealthMetricsCard() {
    final userProfile = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;
    
    // BMI計算
    double? bmi;
    String bmiCategory = '';
    Color bmiColor = Colors.grey;
    
    if (userProfile != null && userProfile.height > 0 && userProfile.weight > 0) {
      final heightInMeters = userProfile.height / 100;
      bmi = userProfile.weight / (heightInMeters * heightInMeters);
      
      if (bmi < 18.5) {
        bmiCategory = '低体重';
        bmiColor = Colors.blue;
      } else if (bmi < 25) {
        bmiCategory = '標準体重';
        bmiColor = Colors.green;
      } else if (bmi < 30) {
        bmiCategory = '肥満度1';
        bmiColor = Colors.orange;
      } else {
        bmiCategory = '肥満度2以上';
        bmiColor = Colors.red;
      }
    }
    
    // 基礎代謝率（BMR）計算 - ハリス・ベネディクト方程式（改定版）
    double? bmr;
    double? tdee;
    if (userProfile != null && userProfile.age > 0 && userProfile.weight > 0 && userProfile.height > 0) {
      if (userProfile.gender == 'male') {
        bmr = (13.397 * userProfile.weight) + (4.799 * userProfile.height) - (5.677 * userProfile.age) + 88.362;
      } else {
        bmr = (9.247 * userProfile.weight) + (3.098 * userProfile.height) - (4.330 * userProfile.age) + 447.593;
      }
      
      // 活動レベルに応じたTDEE計算
      final activityMultipliers = {
        'sedentary': 1.2,
        'lightly_active': 1.375,
        'moderately_active': 1.55,
        'very_active': 1.725,
        'extra_active': 1.9,
      };
      
      tdee = bmr * (activityMultipliers[userProfile.activityLevel] ?? 1.55);
    }
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Color(0xFFFF69B4), size: 24),
                const SizedBox(width: 8),
                Text(
                  '健康指標',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (bmi != null) ...[
              _buildMetricRow(
                'BMI',
                bmi.toStringAsFixed(1),
                bmiCategory,
                bmiColor,
                '標準範囲: 18.5-24.9',
              ),
              const SizedBox(height: 16),
            ],
            if (bmr != null) ...[
              _buildMetricRow(
                '基礎代謝率',
                '${bmr.toStringAsFixed(0)} kcal/日',
                '安静時消費カロリー',
                Colors.blue,
                null,
              ),
              const SizedBox(height: 16),
            ],
            if (tdee != null) ...[
              _buildMetricRow(
                '推定消費カロリー',
                '${tdee.toStringAsFixed(0)} kcal/日',
                '活動量を含む',
                Colors.purple,
                null,
              ),
            ],
            if (userProfile == null)
              Center(
                child: Text(
                  '設定画面でプロフィール情報を入力してください',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMetricRow(String label, String value, String status, Color statusColor, String? reference) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (reference != null) ...[
          const SizedBox(height: 4),
          Text(
            reference,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildPFCBalanceCard() {
    final l10n = AppLocalizations.of(context)!;
    final userProfile = ref.watch(userProfileProvider);
    
    // 推奨PFCバランス（厚生労働省の日本人の食事摂取基準より）
    const recommendedProtein = 15.0; // 13-20%
    const recommendedFat = 25.0; // 20-30%
    const recommendedCarbs = 60.0; // 50-65%
    
    // TODO: 実際のデータから計算
    const actualProtein = 18.0;
    const actualFat = 28.0;
    const actualCarbs = 54.0;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart, color: Color(0xFFFF69B4), size: 24),
                const SizedBox(width: 8),
                Text(
                  'PFCバランス',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            color: Colors.orange,
                            value: actualProtein,
                            title: 'P\n${actualProtein.toStringAsFixed(0)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.blue,
                            value: actualFat,
                            title: 'F\n${actualFat.toStringAsFixed(0)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: actualCarbs,
                            title: 'C\n${actualCarbs.toStringAsFixed(0)}%',
                            radius: 80,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        sectionsSpace: 2,
                        centerSpaceRadius: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildPFCItem(
                        'タンパク質',
                        actualProtein,
                        recommendedProtein,
                        '13-20%',
                        Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      _buildPFCItem(
                        '脂質',
                        actualFat,
                        recommendedFat,
                        '20-30%',
                        Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      _buildPFCItem(
                        '炭水化物',
                        actualCarbs,
                        recommendedCarbs,
                        '50-65%',
                        Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '推奨値は厚生労働省「日本人の食事摂取基準」に基づいています',
                      style: TextStyle(fontSize: 12, color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPFCItem(String name, double actual, double recommended, String range, Color color) {
    final difference = actual - recommended;
    final isOptimal = (actual >= double.parse(range.split('-')[0]) && 
                      actual <= double.parse(range.split('-')[1]));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                Text(name, style: const TextStyle(fontSize: 14)),
              ],
            ),
            Text(
              '${actual.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isOptimal ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '推奨: $range',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (!isOptimal)
              Text(
                difference > 0 ? '+${difference.toStringAsFixed(0)}%' : '${difference.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: difference > 0 ? Colors.red : Colors.blue,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionAssessment() {
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