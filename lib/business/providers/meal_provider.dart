import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/meal.dart';
import '../../data/repositories/meal_repository.dart';
import '../../data/datasources/meal_repository_impl.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepositoryImpl();
});

final mealsProvider = StateNotifierProvider<MealNotifier, AsyncValue<List<Meal>>>((ref) {
  return MealNotifier(ref.watch(mealRepositoryProvider));
});

final mealsByDateProvider = StateNotifierProvider.family<MealsByDateNotifier, AsyncValue<List<Meal>>, DateTime>((ref, date) {
  return MealsByDateNotifier(ref.watch(mealRepositoryProvider), date);
});

class MealNotifier extends StateNotifier<AsyncValue<List<Meal>>> {
  final MealRepository _mealRepository;

  MealNotifier(this._mealRepository) : super(const AsyncValue.loading()) {
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    try {
      final meals = await _mealRepository.getAllMeals();
      state = AsyncValue.data(meals);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveMeal(Meal meal) async {
    try {
      await _mealRepository.saveMeal(meal);
      await _loadMeals(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateMeal(Meal meal) async {
    try {
      await _mealRepository.updateMeal(meal);
      await _loadMeals(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteMeal(String id) async {
    try {
      await _mealRepository.deleteMeal(id);
      await _loadMeals(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshMeals() async {
    await _loadMeals();
  }
}

class MealsByDateNotifier extends StateNotifier<AsyncValue<List<Meal>>> {
  final MealRepository _mealRepository;
  final DateTime _date;

  MealsByDateNotifier(this._mealRepository, this._date) : super(const AsyncValue.loading()) {
    _loadMealsByDate();
  }

  Future<void> _loadMealsByDate() async {
    try {
      final meals = await _mealRepository.getMealsByDate(_date);
      state = AsyncValue.data(meals);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshMeals() async {
    await _loadMealsByDate();
  }
}