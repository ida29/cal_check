import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/providers.dart';
import '../../business/services/setup_service.dart';
import 'dart:math' as math;
import '../../data/entities/meal.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  int _selectedPeriod = 0;
  UserProfile? _userProfile;
  double? _dailyCalorieGoal;
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  Future<void> _loadUserProfile() async {
    final setupService = SetupService();
    final profile = await setupService.getUserProfile();
    final goal = await setupService.calculateDailyCalorieGoal();
    if (mounted) {
      setState(() {
        _userProfile = profile;
        _dailyCalorieGoal = goal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体調管理'),
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
    final calorieData = _getCalorieDataForChart();
    final spots = calorieData['spots'] as List<FlSpot>;
    final average = calorieData['average'] as double;
    final lowest = calorieData['lowest'] as double;
    final highest = calorieData['highest'] as double;
    final minY = calorieData['minY'] as double;
    final maxY = calorieData['maxY'] as double;
    
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
                const Icon(Icons.show_chart, color: Color(0xFFFF69B4), size: 24),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.calorieIntakeTrend,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 500,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 500,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final labels = _getChartLabels();
                          if (value.toInt() < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                labels[value.toInt()],
                                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                              ),
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
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: const Color(0xFFFF69B4),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: const Color(0xFFFF69B4),
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFF69B4).withOpacity(0.3),
                            const Color(0xFFFF69B4).withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // 目標ライン
                    if (_dailyCalorieGoal != null)
                      LineChartBarData(
                        spots: List.generate(
                          spots.length,
                          (index) => FlSpot(index.toDouble(), _dailyCalorieGoal!),
                        ),
                        isCurved: false,
                        color: Colors.green.withOpacity(0.5),
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        dashArray: [5, 5],
                      ),
                  ],
                  minX: 0,
                  maxX: spots.length - 1,
                  minY: minY,
                  maxY: maxY,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toInt()} kcal',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(AppLocalizations.of(context)!.average, '${average.toInt()} cal'),
                _buildStatItem(AppLocalizations.of(context)!.lowest, '${lowest.toInt()} cal'),
                _buildStatItem(AppLocalizations.of(context)!.highest, '${highest.toInt()} cal'),
              ],
            ),
            if (_dailyCalorieGoal != null) ...[  
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag, color: Colors.green[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '目標カロリー: ${_dailyCalorieGoal!.toInt()} kcal/日',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHealthMetricsCard() {
    final userProfile = _userProfile;
    
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
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
    
    // 推奨PFCバランス（厚生労働省の日本人の食事摂取基準より）
    const recommendedProtein = 15.0; // 13-20%
    const recommendedFat = 25.0; // 20-30%
    const recommendedCarbs = 60.0; // 50-65%
    
    // 実際のデータから計算
    final mealsForPeriod = _getMealsForSelectedPeriod();
    final pfcData = _calculatePFCBalance(mealsForPeriod);
    
    final actualProtein = pfcData['protein'] ?? 18.0;
    final actualFat = pfcData['fat'] ?? 28.0;
    final actualCarbs = pfcData['carbs'] ?? 54.0;
    
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
            // 現在と理想の比較表示
            Row(
              children: [
                // 現在のPFCバランス
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '現在',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.orange,
                                value: actualProtein,
                                title: 'P',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.blue,
                                value: actualFat,
                                title: 'F',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.green,
                                value: actualCarbs,
                                title: 'C',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            sectionsSpace: 1,
                            centerSpaceRadius: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 矢印
                Icon(
                  Icons.arrow_forward,
                  color: Colors.grey[400],
                  size: 24,
                ),
                // 理想のPFCバランス
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '理想',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.orange.withOpacity(0.7),
                                value: recommendedProtein,
                                title: 'P',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.blue.withOpacity(0.7),
                                value: recommendedFat,
                                title: 'F',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.green.withOpacity(0.7),
                                value: recommendedCarbs,
                                title: 'C',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            sectionsSpace: 1,
                            centerSpaceRadius: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 詳細な比較
            Column(
              children: [
                _buildPFCComparisonItem(
                  'タンパク質',
                  actualProtein,
                  recommendedProtein,
                  '13-20%',
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildPFCComparisonItem(
                  '脂質',
                  actualFat,
                  recommendedFat,
                  '20-30%',
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildPFCComparisonItem(
                  '炭水化物',
                  actualCarbs,
                  recommendedCarbs,
                  '50-65%',
                  Colors.green,
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
  
  Widget _buildPFCComparisonItem(String name, double actual, double recommended, String range, Color color) {
    final difference = actual - recommended;
    final rangeParts = range.replaceAll('%', '').split('-');
    final isOptimal = (actual >= double.parse(rangeParts[0]) && 
                      actual <= double.parse(rangeParts[1]));
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOptimal ? Colors.green.withOpacity(0.05) : Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOptimal ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOptimal ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOptimal ? '適正' : '要調整',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 比較バー
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '現在',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          '${actual.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: actual / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '推奨',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        Text(
                          range,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: double.parse(rangeParts[1]) / 100,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                        Positioned(
                          left: double.parse(rangeParts[0]) / 100 * MediaQuery.of(context).size.width * 0.7,
                          child: Container(
                            width: (double.parse(rangeParts[1]) - double.parse(rangeParts[0])) / 100 * MediaQuery.of(context).size.width * 0.7,
                            height: 6,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isOptimal) ...[
            const SizedBox(height: 8),
            Text(
              difference > 0 
                ? '${difference.toStringAsFixed(1)}% 多い' 
                : '${difference.abs().toStringAsFixed(1)}% 少ない',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionAssessment() {
    
    // 栄養素の適正摂取量評価
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
                const Icon(Icons.assignment_turned_in, color: Color(0xFFFF69B4), size: 24),
                const SizedBox(width: 8),
                Text(
                  '栄養素摂取評価',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ビタミン・ミネラル評価
            _buildNutrientAssessmentItem('ビタミンA', 75, '目の健康、免疫機能'),
            const Divider(height: 24),
            _buildNutrientAssessmentItem('ビタミンC', 120, '抗酸化作用、コラーゲン生成'),
            const Divider(height: 24),
            _buildNutrientAssessmentItem('ビタミンD', 45, '骨の健康、カルシウム吸収'),
            const Divider(height: 24),
            _buildNutrientAssessmentItem('カルシウム', 68, '骨・歯の形成、筋肉機能'),
            const Divider(height: 24),
            _buildNutrientAssessmentItem('鉄分', 82, '酸素運搬、エネルギー代謝'),
            const Divider(height: 24),
            _buildNutrientAssessmentItem('食物繊維', 65, '腸内環境、血糖値調整'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNutrientAssessmentItem(String nutrient, double percentage, String benefit) {
    Color color;
    String status;
    
    if (percentage >= 100) {
      color = Colors.green;
      status = '充足';
    } else if (percentage >= 70) {
      color = Colors.amber;
      status = 'やや不足';
    } else {
      color = Colors.red;
      status = '不足';
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    nutrient, 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              benefit, 
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 45,
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeightPrediction() {
    final userProfile = _userProfile;
    
    // カロリー収支から体重変化を予測
    // 今日のカロリー摂取量を取得
    final today = DateTime.now();
    final todayMealsAsync = ref.watch(mealsByDateProvider(today));
    final dailyCalorieIntake = todayMealsAsync.maybeWhen(
      data: (meals) => meals.fold<double>(0, (sum, meal) => sum + meal.totalCalories),
      orElse: () => 0.0,
    );
    final tdee = userProfile != null ? _calculateTDEE(userProfile) : 2000.0;
    final dailySurplusDeficit = dailyCalorieIntake - tdee;
    final weeklyChange = (dailySurplusDeficit * 7) / 7700; // 1kg = 7700kcal
    final monthlyChange = weeklyChange * 4;
    
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
                const Icon(Icons.trending_up, color: Color(0xFFFF69B4), size: 24),
                const SizedBox(width: 8),
                Text(
                  '体重変化予測',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dailySurplusDeficit > 0 
                  ? Colors.orange.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: dailySurplusDeficit > 0 
                    ? Colors.orange.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '現在のカロリー収支',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dailySurplusDeficit > 0 ? "+" : ""}${dailySurplusDeficit.toStringAsFixed(0)} kcal/日',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: dailySurplusDeficit > 0 ? Colors.orange : Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dailySurplusDeficit > 0 ? 'カロリー過剰' : 'カロリー不足',
                    style: TextStyle(
                      fontSize: 12,
                      color: dailySurplusDeficit > 0 ? Colors.orange : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildPredictionRow(
              '1週間後',
              weeklyChange,
              userProfile?.weight ?? 60.0,
            ),
            const Divider(height: 24),
            _buildPredictionRow(
              '1ヶ月後',
              monthlyChange,
              userProfile?.weight ?? 60.0,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '※ 体重1kgの変化には約7,700kcalが必要です',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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
  
  Widget _buildPredictionRow(String period, double change, double currentWeight) {
    final predictedWeight = currentWeight + change;
    final changeColor = change > 0 ? Colors.orange : change < 0 ? Colors.blue : Colors.grey;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(period, style: const TextStyle(fontSize: 16)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${predictedWeight.toStringAsFixed(1)} kg',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${change > 0 ? "+" : ""}${change.toStringAsFixed(1)} kg',
              style: TextStyle(fontSize: 14, color: changeColor),
            ),
          ],
        ),
      ],
    );
  }
  
  double _calculateTDEE(UserProfile? userProfile) {
    if (userProfile == null || userProfile.age <= 0 || userProfile.weight <= 0 || userProfile.height <= 0) {
      return 2000.0; // デフォルト値
    }
    
    double bmr;
    if (userProfile.gender == 'male') {
      bmr = (13.397 * userProfile.weight) + (4.799 * userProfile.height) - (5.677 * userProfile.age) + 88.362;
    } else {
      bmr = (9.247 * userProfile.weight) + (3.098 * userProfile.height) - (4.330 * userProfile.age) + 447.593;
    }
    
    final activityMultipliers = {
      'sedentary': 1.2,
      'lightly_active': 1.375,
      'moderately_active': 1.55,
      'very_active': 1.725,
      'extra_active': 1.9,
    };
    
    return bmr * (activityMultipliers[userProfile.activityLevel] ?? 1.55);
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
  
  List<Meal> _getMealsForSelectedPeriod() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final meals = <Meal>[];
    
    int days;
    switch (_selectedPeriod) {
      case 0: // Week
        days = 7;
        break;
      case 1: // Month
        days = 30;
        break;
      case 2: // Year
        days = 365;
        break;
      default:
        days = 7;
    }
    
    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final dayMealsAsync = ref.watch(mealsByDateProvider(date));
      dayMealsAsync.whenData((dayMeals) {
        meals.addAll(dayMeals);
      });
    }
    
    return meals;
  }
  
  Map<String, double> _calculatePFCBalance(List<Meal> meals) {
    if (meals.isEmpty) {
      return {'protein': 15.0, 'fat': 25.0, 'carbs': 60.0};
    }
    
    double totalProtein = 0;
    double totalFat = 0;
    double totalCarbs = 0;
    
    for (final meal in meals) {
      totalProtein += meal.totalNutrition.protein;
      totalFat += meal.totalNutrition.fat;
      totalCarbs += meal.totalNutrition.carbohydrates;
    }
    
    // グラムからカロリーに変換
    final proteinCalories = totalProtein * 4; // 1g = 4kcal
    final fatCalories = totalFat * 9; // 1g = 9kcal
    final carbCalories = totalCarbs * 4; // 1g = 4kcal
    
    final totalMacroCalories = proteinCalories + fatCalories + carbCalories;
    
    if (totalMacroCalories == 0) {
      return {'protein': 15.0, 'fat': 25.0, 'carbs': 60.0};
    }
    
    return {
      'protein': (proteinCalories / totalMacroCalories) * 100,
      'fat': (fatCalories / totalMacroCalories) * 100,
      'carbs': (carbCalories / totalMacroCalories) * 100,
    };
  }
  
  Map<String, dynamic> _getCalorieDataForChart() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final spots = <FlSpot>[];
    final calorieValues = <double>[];
    
    int days;
    switch (_selectedPeriod) {
      case 0: // Week
        days = 7;
        break;
      case 1: // Month
        days = 30;
        break;
      case 2: // Year
        days = 12; // 月ごとの平均
        break;
      default:
        days = 7;
    }
    
    for (int i = days - 1; i >= 0; i--) {
      double dayCalories = 0;
      
      if (_selectedPeriod == 2) { // Year - 月ごと
        final monthStart = DateTime(today.year, today.month - i, 1);
        final monthEnd = DateTime(today.year, today.month - i + 1, 0);
        int totalDays = 0;
        
        for (int day = 0; day <= monthEnd.day - 1; day++) {
          final date = monthStart.add(Duration(days: day));
          final dayMealsAsync = ref.watch(mealsByDateProvider(date));
          dayMealsAsync.whenData((dayMeals) {
            if (dayMeals.isNotEmpty) {
              totalDays++;
              dayCalories += dayMeals.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
            }
          });
        }
        
        if (totalDays > 0) {
          dayCalories = dayCalories / totalDays; // 月平均
        }
      } else {
        final date = today.subtract(Duration(days: i));
        final dayMealsAsync = ref.watch(mealsByDateProvider(date));
        dayMealsAsync.whenData((dayMeals) {
          dayCalories = dayMeals.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
        });
      }
      
      spots.add(FlSpot(spots.length.toDouble(), dayCalories));
      if (dayCalories > 0) calorieValues.add(dayCalories);
    }
    
    // スポットが空の場合のデフォルト値
    if (spots.isEmpty) {
      spots.addAll([
        FlSpot(0, 1800),
        FlSpot(1, 2100),
        FlSpot(2, 1950),
        FlSpot(3, 2200),
        FlSpot(4, 1900),
        FlSpot(5, 2000),
        FlSpot(6, 1770),
      ]);
      calorieValues.addAll([1800, 2100, 1950, 2200, 1900, 2000, 1770]);
    }
    
    final average = calorieValues.isEmpty ? 2000.0 : calorieValues.reduce((a, b) => a + b) / calorieValues.length;
    final lowest = calorieValues.isEmpty ? 1500.0 : calorieValues.reduce(math.min);
    final highest = calorieValues.isEmpty ? 2500.0 : calorieValues.reduce(math.max);
    
    // Y軸の範囲を計算
    double minY = (lowest - 500).floorToDouble();
    double maxY = (highest + 500).ceilToDouble();
    if (minY < 0) minY = 0;
    
    return {
      'spots': spots,
      'average': average,
      'lowest': lowest,
      'highest': highest,
      'minY': minY,
      'maxY': maxY,
    };
  }
  
  List<String> _getChartLabels() {
    final now = DateTime.now();
    final labels = <String>[];
    
    switch (_selectedPeriod) {
      case 0: // Week
        final weekDays = ['月', '火', '水', '木', '金', '土', '日'];
        for (int i = 6; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          labels.add(weekDays[date.weekday - 1]);
        }
        break;
      case 1: // Month
        for (int i = 29; i >= 0; i--) {
          final date = now.subtract(Duration(days: i));
          if (i % 5 == 0) {
            labels.add('${date.month}/${date.day}');
          } else {
            labels.add('');
          }
        }
        break;
      case 2: // Year
        final months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
        for (int i = 11; i >= 0; i--) {
          final monthIndex = (now.month - i - 1) % 12;
          labels.add(months[monthIndex < 0 ? monthIndex + 12 : monthIndex]);
        }
        break;
    }
    
    return labels;
  }
}