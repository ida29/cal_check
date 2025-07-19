import '../entities/food_item.dart';
import '../entities/nutrition_info.dart';

abstract class FoodDatabaseRepository {
  Future<List<FoodItem>> searchFoodItems(String query);
  Future<FoodItem?> getFoodItemById(String id);
  Future<NutritionInfo?> getNutritionInfo(String foodId);
  Future<void> addCustomFoodItem(FoodItem foodItem);
  Future<List<FoodItem>> getCustomFoodItems();
  Future<void> updateCustomFoodItem(FoodItem foodItem);
  Future<void> deleteCustomFoodItem(String id);
}