import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/meal.dart';
import '../models/daily_stats.dart';
import '../models/weekly_stats.dart';
import '../services/calorie_calculation_service.dart';
import 'meal_provider.dart';
import 'exercise_provider.dart';
import 'user_provider.dart';

final calorieCalculationServiceProvider = Provider<CalorieCalculationService>((ref) {
  return CalorieCalculationService();
});

final dailyStatsProvider = StateNotifierProvider.family<DailyStatsNotifier, AsyncValue<DailyStats?>, DateTime>((ref, date) {
  return DailyStatsNotifier(
    date,
    ref.watch(mealRepositoryProvider),
    ref.watch(exerciseRepositoryProvider),
    ref.watch(calorieCalculationServiceProvider),
    ref.watch(userProvider),
  );
});

final weeklyStatsProvider = StateNotifierProvider.family<WeeklyStatsNotifier, AsyncValue<WeeklyStats?>, DateTime>((ref, startDate) {
  return WeeklyStatsNotifier(
    startDate,
    ref.watch(mealRepositoryProvider),
    ref.watch(calorieCalculationServiceProvider),
    ref.watch(userProvider),
  );
});

final todayStatsProvider = Provider<AsyncValue<DailyStats?>>((ref) {
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  return ref.watch(dailyStatsProvider(todayStart));
});

class DailyStatsNotifier extends StateNotifier<AsyncValue<DailyStats?>> {
  final DateTime _date;
  final dynamic _mealRepository;
  final dynamic _exerciseRepository;
  final CalorieCalculationService _calculationService;
  final AsyncValue _userState;

  DailyStatsNotifier(
    this._date,
    this._mealRepository,
    this._exerciseRepository,
    this._calculationService,
    this._userState,
  ) : super(const AsyncValue.loading()) {
    _loadDailyStats();
  }

  Future<void> _loadDailyStats() async {
    try {
      final meals = await _mealRepository.getMealsByDate(_date);
      final exercises = await _exerciseRepository.getExercisesByDate(_date);
      
      _userState.when(
        data: (user) {
          if (user != null) {
            final targetCalories = user.targetCalories;
            final dailyStatistics = _calculationService.calculateDailyStatistics(meals, targetCalories);
            
            final totalCaloriesBurned = exercises.fold(0.0, (sum, exercise) => sum + exercise.caloriesBurned);
            final totalExerciseMinutes = exercises.fold(0, (sum, exercise) => sum + exercise.durationMinutes);
            
            final stats = DailyStats(
              date: _date,
              totalCalories: dailyStatistics['totalCalories'],
              targetCalories: targetCalories,
              totalNutrition: dailyStatistics['totalNutrition'],
              mealCount: dailyStatistics['mealCount'],
              mealTypeBreakdown: Map<String, double>.from(dailyStatistics['mealTypeBreakdown']),
              calorieGoalProgress: dailyStatistics['calorieProgress'],
              totalCaloriesBurned: totalCaloriesBurned,
              exerciseCount: exercises.length,
              totalExerciseMinutes: totalExerciseMinutes,
            );
            
            state = AsyncValue.data(stats);
          } else {
            state = const AsyncValue.data(null);
          }
        },
        loading: () => state = const AsyncValue.loading(),
        error: (error, stackTrace) => state = AsyncValue.error(error, stackTrace),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshStats() async {
    await _loadDailyStats();
  }
}

class WeeklyStatsNotifier extends StateNotifier<AsyncValue<WeeklyStats?>> {
  final DateTime _startDate;
  final dynamic _mealRepository;
  final CalorieCalculationService _calculationService;
  final AsyncValue _userState;

  WeeklyStatsNotifier(
    this._startDate,
    this._mealRepository,
    this._calculationService,
    this._userState,
  ) : super(const AsyncValue.loading()) {
    _loadWeeklyStats();
  }

  Future<void> _loadWeeklyStats() async {
    try {
      final endDate = _startDate.add(const Duration(days: 7));
      final meals = await _mealRepository.getMealsByDateRange(_startDate, endDate);
      
      _userState.when(
        data: (user) {
          if (user != null) {
            final targetCalories = user.targetCalories;
            final dailyStatsList = <DailyStats>[];
            final caloriesTrend = <double>[];
            
            for (int i = 0; i < 7; i++) {
              final date = _startDate.add(Duration(days: i));
              final dayMeals = meals.where((meal) {
                final mealDate = DateTime(meal.timestamp.year, meal.timestamp.month, meal.timestamp.day);
                return mealDate.isAtSameMomentAs(date);
              }).toList();
              
              final dailyStats = _calculationService.calculateDailyStatistics(dayMeals, targetCalories);
              final dailyCalories = dailyStats['totalCalories'] as double;
              
              caloriesTrend.add(dailyCalories);
              
              final stats = DailyStats(
                date: date,
                totalCalories: dailyCalories,
                targetCalories: targetCalories,
                totalNutrition: dailyStats['totalNutrition'],
                mealCount: dailyStats['mealCount'],
                mealTypeBreakdown: Map<String, double>.from(dailyStats['mealTypeBreakdown']),
                calorieGoalProgress: dailyStats['calorieProgress'],
              );
              
              dailyStatsList.add(stats);
            }
            
            final totalCalories = caloriesTrend.fold(0.0, (sum, calories) => sum + calories);
            final averageCalories = totalCalories / 7;
            final totalMeals = meals.length;
            
            final weeklyStats = WeeklyStats(
              startDate: _startDate,
              endDate: endDate,
              dailyStats: dailyStatsList,
              averageCalories: averageCalories,
              totalCalories: totalCalories,
              targetCalories: targetCalories * 7,
              totalMeals: totalMeals,
              nutritionAverages: _calculateNutritionAverages(dailyStatsList),
              caloriesTrend: caloriesTrend,
            );
            
            state = AsyncValue.data(weeklyStats);
          } else {
            state = const AsyncValue.data(null);
          }
        },
        loading: () => state = const AsyncValue.loading(),
        error: (error, stackTrace) => state = AsyncValue.error(error, stackTrace),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Map<String, double> _calculateNutritionAverages(List<DailyStats> dailyStats) {
    if (dailyStats.isEmpty) {
      return {'protein': 0.0, 'carbohydrates': 0.0, 'fat': 0.0};
    }

    final totalProtein = dailyStats.fold(0.0, (sum, stats) => sum + stats.totalNutrition.protein);
    final totalCarbs = dailyStats.fold(0.0, (sum, stats) => sum + stats.totalNutrition.carbohydrates);
    final totalFat = dailyStats.fold(0.0, (sum, stats) => sum + stats.totalNutrition.fat);

    return {
      'protein': totalProtein / dailyStats.length,
      'carbohydrates': totalCarbs / dailyStats.length,
      'fat': totalFat / dailyStats.length,
    };
  }

  Future<void> refreshStats() async {
    await _loadWeeklyStats();
  }
}