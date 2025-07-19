import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/user.dart';

class CalorieCalculationService {
  static final CalorieCalculationService _instance = CalorieCalculationService._internal();
  factory CalorieCalculationService() => _instance;
  CalorieCalculationService._internal();

  double calculateTotalCalories(List<FoodItem> foodItems) {
    return foodItems.fold(0.0, (total, item) => total + item.calories);
  }

  NutritionInfo calculateTotalNutrition(List<FoodItem> foodItems) {
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;
    double totalFiber = 0.0;
    double totalSugar = 0.0;
    double totalSodium = 0.0;

    for (final item in foodItems) {
      final ratio = item.quantity / 100; // Assuming nutrition is per 100g
      totalProtein += item.nutritionInfo.protein * ratio;
      totalCarbs += item.nutritionInfo.carbohydrates * ratio;
      totalFat += item.nutritionInfo.fat * ratio;
      totalFiber += item.nutritionInfo.fiber * ratio;
      totalSugar += item.nutritionInfo.sugar * ratio;
      totalSodium += item.nutritionInfo.sodium * ratio;
    }

    return NutritionInfo(
      protein: totalProtein,
      carbohydrates: totalCarbs,
      fat: totalFat,
      fiber: totalFiber,
      sugar: totalSugar,
      sodium: totalSodium,
    );
  }

  double calculateCaloriesFromMacros(double protein, double carbs, double fat) {
    return (protein * 4) + (carbs * 4) + (fat * 9);
  }

  double adjustCaloriesForPortion(double baseCalories, double actualQuantity, double baseQuantity) {
    return baseCalories * (actualQuantity / baseQuantity);
  }

  FoodItem adjustFoodItemPortion(FoodItem item, double newQuantity) {
    final ratio = newQuantity / item.quantity;
    
    return item.copyWith(
      quantity: newQuantity,
      calories: item.calories * ratio,
      nutritionInfo: NutritionInfo(
        protein: item.nutritionInfo.protein * ratio,
        carbohydrates: item.nutritionInfo.carbohydrates * ratio,
        fat: item.nutritionInfo.fat * ratio,
        fiber: item.nutritionInfo.fiber * ratio,
        sugar: item.nutritionInfo.sugar * ratio,
        sodium: item.nutritionInfo.sodium * ratio,
      ),
    );
  }

  double calculateBasalMetabolicRate(User user) {
    double bmr;
    
    if (user.gender == Gender.male) {
      bmr = 88.362 + (13.397 * user.weight) + (4.799 * user.height) - (5.677 * user.age);
    } else {
      bmr = 447.593 + (9.247 * user.weight) + (3.098 * user.height) - (4.330 * user.age);
    }
    
    return bmr;
  }

  double calculateTotalDailyEnergyExpenditure(User user) {
    final bmr = calculateBasalMetabolicRate(user);
    
    final activityMultipliers = {
      ActivityLevel.sedentary: 1.2,
      ActivityLevel.lightlyActive: 1.375,
      ActivityLevel.moderatelyActive: 1.55,
      ActivityLevel.veryActive: 1.725,
      ActivityLevel.extraActive: 1.9,
    };
    
    return bmr * (activityMultipliers[user.activityLevel] ?? 1.55);
  }

  double calculateRecommendedCalories(User user, {String goal = 'maintain'}) {
    final tdee = calculateTotalDailyEnergyExpenditure(user);
    
    switch (goal.toLowerCase()) {
      case 'lose':
        return tdee - 500; // 1 lb per week weight loss
      case 'gain':
        return tdee + 500; // 1 lb per week weight gain
      case 'maintain':
      default:
        return tdee;
    }
  }

  Map<String, double> calculateMacroBreakdown(NutritionInfo nutrition, double totalCalories) {
    if (totalCalories == 0) {
      return {'protein': 0.0, 'carbohydrates': 0.0, 'fat': 0.0};
    }

    final proteinCalories = nutrition.protein * 4;
    final carbCalories = nutrition.carbohydrates * 4;
    final fatCalories = nutrition.fat * 9;

    return {
      'protein': (proteinCalories / totalCalories) * 100,
      'carbohydrates': (carbCalories / totalCalories) * 100,
      'fat': (fatCalories / totalCalories) * 100,
    };
  }

  double calculateDayProgress(double consumed, double target) {
    if (target == 0) return 0.0;
    return (consumed / target).clamp(0.0, 1.0);
  }

  bool isOverTarget(double consumed, double target, {double threshold = 1.1}) {
    return consumed > (target * threshold);
  }

  Map<String, dynamic> calculateDailyStatistics(List<Meal> meals, double targetCalories) {
    final totalCalories = meals.fold(0.0, (sum, meal) => sum + meal.totalCalories);
    
    final totalNutrition = meals.fold(
      const NutritionInfo(protein: 0, carbohydrates: 0, fat: 0),
      (sum, meal) => NutritionInfo(
        protein: sum.protein + meal.totalNutrition.protein,
        carbohydrates: sum.carbohydrates + meal.totalNutrition.carbohydrates,
        fat: sum.fat + meal.totalNutrition.fat,
        fiber: sum.fiber + meal.totalNutrition.fiber,
        sugar: sum.sugar + meal.totalNutrition.sugar,
        sodium: sum.sodium + meal.totalNutrition.sodium,
      ),
    );

    final mealTypeBreakdown = <String, double>{};
    for (final meal in meals) {
      final type = meal.mealType.name;
      mealTypeBreakdown[type] = (mealTypeBreakdown[type] ?? 0) + meal.totalCalories;
    }

    final progress = calculateDayProgress(totalCalories, targetCalories);
    final macroBreakdown = calculateMacroBreakdown(totalNutrition, totalCalories);

    return {
      'totalCalories': totalCalories,
      'targetCalories': targetCalories,
      'totalNutrition': totalNutrition,
      'mealCount': meals.length,
      'mealTypeBreakdown': mealTypeBreakdown,
      'calorieProgress': progress,
      'macroBreakdown': macroBreakdown,
      'isOverTarget': isOverTarget(totalCalories, targetCalories),
    };
  }

  List<String> generateNutritionInsights(Map<String, dynamic> dailyStats, User user) {
    final insights = <String>[];
    final totalCalories = dailyStats['totalCalories'] as double;
    final targetCalories = dailyStats['targetCalories'] as double;
    final macroBreakdown = dailyStats['macroBreakdown'] as Map<String, double>;
    final isOverTarget = dailyStats['isOverTarget'] as bool;

    if (isOverTarget) {
      final excess = totalCalories - targetCalories;
      insights.add('You\'ve exceeded your daily calorie goal by ${excess.round()} calories.');
    } else if (totalCalories < targetCalories * 0.8) {
      final deficit = targetCalories - totalCalories;
      insights.add('You\'re ${deficit.round()} calories below your daily goal. Consider a healthy snack.');
    }

    if (macroBreakdown['protein']! < 15) {
      insights.add('Your protein intake is low. Try adding lean meats, eggs, or legumes.');
    }

    if (macroBreakdown['fat']! > 35) {
      insights.add('Your fat intake is high. Consider reducing fried foods and adding more vegetables.');
    }

    if (macroBreakdown['carbohydrates']! > 60) {
      insights.add('Your carbohydrate intake is high. Balance with more protein and healthy fats.');
    }

    return insights;
  }
}