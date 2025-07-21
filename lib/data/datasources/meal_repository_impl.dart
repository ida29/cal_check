import 'dart:convert';
import '../repositories/meal_repository.dart';
import '../entities/meal.dart';
import '../entities/food_item.dart';
import '../entities/nutrition_info.dart';
import 'database_helper.dart';

class MealRepositoryImpl implements MealRepository {
  final DatabaseHelper _databaseHelper;

  MealRepositoryImpl({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper();

  @override
  Future<List<Meal>> getAllMeals() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> mealMaps = await db.query(
      'meals',
      orderBy: 'timestamp DESC',
    );

    return Future.wait(mealMaps.map((mealMap) => _mapToMeal(mealMap)));
  }

  @override
  Future<List<Meal>> getMealsByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> mealMaps = await db.query(
      'meals',
      where: 'timestamp >= ? AND timestamp <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );

    return Future.wait(mealMaps.map((mealMap) => _mapToMeal(mealMap)));
  }

  @override
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getMealsByDateRange(startOfDay, endOfDay);
  }

  @override
  Future<Meal?> getMealById(String id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> mealMaps = await db.query(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (mealMaps.isEmpty) {
      return null;
    }

    return _mapToMeal(mealMaps.first);
  }

  @override
  Future<void> saveMeal(Meal meal) async {
    final db = await _databaseHelper.database;
    
    await db.transaction((txn) async {
      await txn.insert('meals', _mealToMap(meal));
      
      for (final foodItem in meal.foodItems) {
        await txn.insert('food_items', _foodItemToMap(foodItem, meal.id));
      }
    });
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    final db = await _databaseHelper.database;
    
    await db.transaction((txn) async {
      await txn.update(
        'meals',
        _mealToMap(meal),
        where: 'id = ?',
        whereArgs: [meal.id],
      );
      
      await txn.delete(
        'food_items',
        where: 'meal_id = ?',
        whereArgs: [meal.id],
      );
      
      for (final foodItem in meal.foodItems) {
        await txn.insert('food_items', _foodItemToMap(foodItem, meal.id));
      }
    });
  }

  @override
  Future<void> deleteMeal(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllMeals() async {
    final db = await _databaseHelper.database;
    await db.delete('meals');
  }

  @override
  Future<List<Meal>> getUnsyncedMeals() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> mealMaps = await db.query(
      'meals',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'timestamp DESC',
    );

    return Future.wait(mealMaps.map((mealMap) => _mapToMeal(mealMap)));
  }

  @override
  Future<void> markMealsAsSynced(List<String> mealIds) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();
    
    for (final id in mealIds) {
      batch.update(
        'meals',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    
    await batch.commit();
  }

  Future<Meal> _mapToMeal(Map<String, dynamic> mealMap) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> foodItemMaps = await db.query(
      'food_items',
      where: 'meal_id = ?',
      whereArgs: [mealMap['id']],
    );

    // Build food items directly without using fromJson
    final foodItems = foodItemMaps.map((map) {
      // Parse nutrition info from JSON string
      final nutritionInfoData = jsonDecode(map['nutrition_info'] as String);
      
      return FoodItem(
        id: map['id'] as String,
        name: map['name'] as String,
        quantity: (map['quantity'] as num).toDouble(),
        unit: map['unit'] as String,
        calories: (map['calories'] as num).toDouble(),
        nutritionInfo: NutritionInfo(
          protein: (nutritionInfoData['protein'] as num).toDouble(),
          carbohydrates: (nutritionInfoData['carbohydrates'] as num).toDouble(),
          fat: (nutritionInfoData['fat'] as num).toDouble(),
          fiber: (nutritionInfoData['fiber'] as num).toDouble(),
          sugar: (nutritionInfoData['sugar'] as num).toDouble(),
          sodium: (nutritionInfoData['sodium'] as num).toDouble(),
        ),
        confidenceScore: (map['confidence_score'] as num).toDouble(),
        imageUrl: map['image_url'] as String?,
      );
    }).toList();

    // Parse total nutrition from JSON string
    final totalNutritionData = jsonDecode(mealMap['total_nutrition'] as String);
    
    return Meal(
      id: mealMap['id'] as String,
      timestamp: DateTime.parse(mealMap['timestamp'] as String),
      mealType: MealType.values.firstWhere(
        (e) => e.name == mealMap['meal_type'],
        orElse: () => MealType.breakfast,
      ),
      imagePath: mealMap['image_path'] as String,
      foodItems: foodItems,
      totalCalories: (mealMap['total_calories'] as num).toDouble(),
      totalNutrition: NutritionInfo(
        protein: (totalNutritionData['protein'] as num).toDouble(),
        carbohydrates: (totalNutritionData['carbohydrates'] as num).toDouble(),
        fat: (totalNutritionData['fat'] as num).toDouble(),
        fiber: (totalNutritionData['fiber'] as num).toDouble(),
        sugar: (totalNutritionData['sugar'] as num).toDouble(),
        sodium: (totalNutritionData['sodium'] as num).toDouble(),
      ),
      notes: mealMap['notes'] as String?,
      isSynced: mealMap['is_synced'] == 1,
      isManualEntry: mealMap['is_manual_entry'] == 1,
    );
  }

  Map<String, dynamic> _mealToMap(Meal meal) {
    return {
      'id': meal.id,
      'timestamp': meal.timestamp.toIso8601String(),
      'meal_type': meal.mealType.name,
      'image_path': meal.imagePath,
      'total_calories': meal.totalCalories,
      'total_nutrition': jsonEncode(meal.totalNutrition.toJson()),
      'notes': meal.notes,
      'is_synced': meal.isSynced ? 1 : 0,
      'is_manual_entry': meal.isManualEntry ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  Map<String, dynamic> _foodItemToMap(FoodItem item, String mealId) {
    return {
      'id': item.id,
      'meal_id': mealId,
      'name': item.name,
      'quantity': item.quantity,
      'unit': item.unit,
      'calories': item.calories,
      'nutrition_info': jsonEncode(item.nutritionInfo.toJson()),
      'confidence_score': item.confidenceScore,
      'image_url': item.imageUrl,
    };
  }
}