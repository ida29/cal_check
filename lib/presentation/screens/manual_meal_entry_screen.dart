import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/datasources/food_database.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../../data/entities/meal.dart';
import '../../business/providers/meal_provider.dart';

class ManualMealEntryScreen extends ConsumerStatefulWidget {
  const ManualMealEntryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ManualMealEntryScreen> createState() => _ManualMealEntryScreenState();
}

class _ManualMealEntryScreenState extends ConsumerState<ManualMealEntryScreen> {
  final _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _searchResults = [];
  List<FoodItem> _selectedFoods = [];
  String _selectedCategory = 'all';
  DateTime _selectedDate = DateTime.now();
  MealType _selectedMealType = MealType.lunch;
  bool _isSaving = false;
  Map<String, double> _foodQuantities = {};
  
  final Map<String, String> _categoryNames = {
    'all': 'すべて',
    'rice': 'ご飯・パン',
    'noodles': '麺類',
    'meat': '肉類',
    'fish': '魚介類',
    'egg': '卵',
    'dairy': '乳製品',
    'vegetable': '野菜',
    'fruit': '果物',
    'beans': '豆類',
    'drink': '飲み物',
    'sweets': 'お菓子',
    'fastfood': 'ファーストフード',
    'meal': '定食・料理',
  };

  @override
  void initState() {
    super.initState();
    _determineDefaultMealType();
    _loadAllFoods();
  }

  void _determineDefaultMealType() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      _selectedMealType = MealType.breakfast;
    } else if (hour < 15) {
      _selectedMealType = MealType.lunch;
    } else if (hour < 21) {
      _selectedMealType = MealType.dinner;
    } else {
      _selectedMealType = MealType.snack;
    }
  }

  void _loadAllFoods() {
    setState(() {
      _searchResults = FoodDatabase.foods;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('食事を手動で記録'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF69B4),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 日付選択バー
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFFF69B4).withOpacity(0.05),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFFFF69B4)),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFF69B4)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                        style: const TextStyle(
                          color: Color(0xFFFF69B4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 食事タイプ選択
                DropdownButton<MealType>(
                  value: _selectedMealType,
                  onChanged: (MealType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedMealType = newValue;
                      });
                    }
                  },
                  items: MealType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getMealTypeLabel(type)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          
          // 検索バー
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '食べ物を検索...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFFFF69B4)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFFF69B4), width: 2),
                ),
              ),
              onChanged: _searchFood,
            ),
          ),
          
          // カテゴリフィルター
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categoryNames.entries.map((entry) {
                final isSelected = _selectedCategory == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? entry.key : 'all';
                        _filterByCategory();
                      });
                    },
                    backgroundColor: isSelected 
                      ? const Color(0xFFFF69B4).withOpacity(0.2)
                      : Colors.grey.shade200,
                    selectedColor: const Color(0xFFFF69B4).withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFFFF69B4) : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // 食品リスト
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final food = _searchResults[index];
                return _buildFoodCard(food);
              },
            ),
          ),
          
          // 選択した食品の表示とボタン
          if (_selectedFoods.isNotEmpty)
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '選択中: ${_selectedFoods.length}品',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '合計: ${_getTotalCalories().toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          color: Color(0xFFFF69B4),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveMeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF69B4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '食事を記録',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    final foodId = '${food['name']}_${food['category']}';
    final isSelected = _selectedFoods.any((f) => f.id == foodId);
    final quantity = _foodQuantities[foodId] ?? 1.0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 3 : 1,
      color: isSelected ? const Color(0xFFFF69B4).withOpacity(0.1) : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getCategoryColor(food['category']).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(food['category']),
            color: _getCategoryColor(food['category']),
          ),
        ),
        title: Text(
          food['name'],
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              '${(food['calories'] * quantity).toStringAsFixed(0)}kcal',
              style: TextStyle(
                color: const Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text('/ ${food['unit']}'),
          ],
        ),
        trailing: isSelected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 数量調整
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFFF69B4)),
                  onPressed: () => _updateQuantity(foodId, -0.5),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Container(
                  width: 50,
                  child: Text(
                    quantity == quantity.toInt() 
                      ? '${quantity.toInt()}個'
                      : '${quantity}個',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFF69B4)),
                  onPressed: () => _updateQuantity(foodId, 0.5),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _toggleFood(food),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _toggleFood(food),
              color: const Color(0xFFFF69B4),
            ),
      ),
    );
  }

  String _getMealTypeLabel(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return '朝食';
      case MealType.lunch:
        return '昼食';
      case MealType.dinner:
        return '夕食';
      case MealType.snack:
        return '間食';
    }
  }

  void _searchFood(String query) {
    setState(() {
      if (query.isEmpty) {
        _filterByCategory();
      } else {
        _searchResults = FoodDatabase.searchFood(query);
        if (_selectedCategory != 'all') {
          _searchResults = _searchResults
              .where((food) => food['category'] == _selectedCategory)
              .toList();
        }
      }
    });
  }

  void _filterByCategory() {
    setState(() {
      if (_selectedCategory == 'all') {
        _searchResults = _searchController.text.isEmpty
            ? FoodDatabase.foods
            : FoodDatabase.searchFood(_searchController.text);
      } else {
        _searchResults = FoodDatabase.getFoodsByCategory(_selectedCategory);
        if (_searchController.text.isNotEmpty) {
          final query = _searchController.text.toLowerCase();
          _searchResults = _searchResults
              .where((food) => food['name'].toString().toLowerCase().contains(query))
              .toList();
        }
      }
    });
  }

  void _toggleFood(Map<String, dynamic> food) {
    final foodId = '${food['name']}_${food['category']}';
    
    setState(() {
      final existingIndex = _selectedFoods.indexWhere((f) => f.id == foodId);
      
      if (existingIndex >= 0) {
        _selectedFoods.removeAt(existingIndex);
        _foodQuantities.remove(foodId);
      } else {
        _foodQuantities[foodId] = 1.0;
        _selectedFoods.add(FoodItem(
          id: foodId,
          name: food['name'],
          quantity: 1.0,
          unit: food['unit'],
          calories: food['calories'].toDouble(),
          nutritionInfo: NutritionInfo(
            protein: food['protein'].toDouble(),
            carbohydrates: food['carbs'].toDouble(),
            fat: food['fat'].toDouble(),
            fiber: 0.0,
            sugar: 0.0,
            sodium: 0.0,
          ),
          confidenceScore: 1.0,
        ));
      }
    });
  }

  void _updateQuantity(String foodId, double change) {
    setState(() {
      final currentQuantity = _foodQuantities[foodId] ?? 1.0;
      final newQuantity = (currentQuantity + change).clamp(0.5, 10.0);
      _foodQuantities[foodId] = newQuantity;
      
      // Update the food item with new quantity
      final index = _selectedFoods.indexWhere((f) => f.id == foodId);
      if (index >= 0) {
        final food = _selectedFoods[index];
        final baseCalories = food.calories / food.quantity;
        _selectedFoods[index] = food.copyWith(
          quantity: newQuantity,
          calories: baseCalories * newQuantity,
          nutritionInfo: NutritionInfo(
            protein: (food.nutritionInfo.protein / food.quantity) * newQuantity,
            carbohydrates: (food.nutritionInfo.carbohydrates / food.quantity) * newQuantity,
            fat: (food.nutritionInfo.fat / food.quantity) * newQuantity,
            fiber: (food.nutritionInfo.fiber / food.quantity) * newQuantity,
            sugar: (food.nutritionInfo.sugar / food.quantity) * newQuantity,
            sodium: (food.nutritionInfo.sodium / food.quantity) * newQuantity,
          ),
        );
      }
    });
  }

  double _getTotalCalories() {
    return _selectedFoods.fold(0.0, (sum, food) => sum + food.calories);
  }

  NutritionInfo _getTotalNutrition() {
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;
    double totalFiber = 0.0;
    double totalSugar = 0.0;
    double totalSodium = 0.0;

    for (final food in _selectedFoods) {
      totalProtein += food.nutritionInfo.protein;
      totalCarbs += food.nutritionInfo.carbohydrates;
      totalFat += food.nutritionInfo.fat;
      totalFiber += food.nutritionInfo.fiber;
      totalSugar += food.nutritionInfo.sugar;
      totalSodium += food.nutritionInfo.sodium;
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'rice':
      case 'bread':
      case 'noodles':
        return Colors.orange;
      case 'meat':
        return Colors.red;
      case 'fish':
        return Colors.blue;
      case 'vegetable':
        return Colors.green;
      case 'fruit':
        return Colors.pink;
      case 'dairy':
      case 'egg':
        return Colors.amber;
      case 'beans':
        return Colors.brown;
      case 'drink':
        return Colors.cyan;
      case 'sweets':
        return Colors.purple;
      case 'fastfood':
        return Colors.deepOrange;
      case 'meal':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'rice':
      case 'bread':
      case 'noodles':
        return Icons.rice_bowl;
      case 'meat':
        return Icons.kebab_dining;
      case 'fish':
        return Icons.set_meal;
      case 'vegetable':
        return Icons.eco;
      case 'fruit':
        return Icons.apple;
      case 'dairy':
      case 'egg':
        return Icons.egg;
      case 'beans':
        return Icons.grain;
      case 'drink':
        return Icons.local_drink;
      case 'sweets':
        return Icons.cake;
      case 'fastfood':
        return Icons.fastfood;
      case 'meal':
        return Icons.restaurant;
      default:
        return Icons.restaurant_menu;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveMeal() async {
    if (_selectedFoods.isEmpty) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // Create meal with selected date and time
      final meal = Meal(
        id: const Uuid().v4(),
        timestamp: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
        ),
        mealType: _selectedMealType,
        imagePath: '', // No image for manual entry
        foodItems: _selectedFoods,
        totalCalories: _getTotalCalories(),
        totalNutrition: _getTotalNutrition(),
        isManualEntry: true,
      );
      
      await ref.read(mealsProvider.notifier).saveMeal(meal);
      
      // Refresh the provider for the selected date
      await ref.read(mealsByDateProvider(_selectedDate).notifier).refreshMeals();
      
      if (mounted) {
        // Show success modal
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text('記録完了'),
                ],
              ),
              content: Text('${_getMealTypeLabel(_selectedMealType)}を記録しました'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close screen
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}