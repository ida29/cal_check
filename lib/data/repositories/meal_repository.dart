import '../entities/meal.dart';

abstract class MealRepository {
  Future<List<Meal>> getAllMeals();
  Future<List<Meal>> getMealsByDateRange(DateTime start, DateTime end);
  Future<List<Meal>> getMealsByDate(DateTime date);
  Future<Meal?> getMealById(String id);
  Future<void> saveMeal(Meal meal);
  Future<void> updateMeal(Meal meal);
  Future<void> deleteMeal(String id);
  Future<void> deleteAllMeals();
  Future<List<Meal>> getUnsyncedMeals();
  Future<void> markMealsAsSynced(List<String> mealIds);
}