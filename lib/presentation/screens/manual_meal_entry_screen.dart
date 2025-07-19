import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/datasources/food_database.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../../data/entities/meal_record.dart';
import '../../business/services/local_photo_storage_service.dart';
import '../../business/services/record_storage_service.dart';

class ManualMealEntryScreen extends StatefulWidget {
  const ManualMealEntryScreen({Key? key}) : super(key: key);

  @override
  State<ManualMealEntryScreen> createState() => _ManualMealEntryScreenState();
}

class _ManualMealEntryScreenState extends State<ManualMealEntryScreen> {
  final _searchController = TextEditingController();
  final _quantityController = TextEditingController();
  final LocalPhotoStorageService _storageService = LocalPhotoStorageService();
  final RecordStorageService _recordStorageService = RecordStorageService();
  
  List<Map<String, dynamic>> _searchResults = [];
  List<FoodItem> _selectedFoods = [];
  String _selectedCategory = 'all';
  String _selectedMealType = 'lunch';
  bool _isSaving = false;
  
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
      _selectedMealType = 'breakfast';
    } else if (hour < 15) {
      _selectedMealType = 'lunch';
    } else if (hour < 21) {
      _selectedMealType = 'dinner';
    } else {
      _selectedMealType = 'snack';
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
      ),
      body: Column(
        children: [
          // 検索バー
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '食べ物を検索...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _searchFood,
            ),
          ),
          
          // カテゴリフィルター
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Colors.grey.shade200,
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
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
              padding: const EdgeInsets.all(16),
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final food = _searchResults[index];
                return _buildFoodCard(food);
              },
            ),
          ),
          
          // 選択した食品の表示
          if (_selectedFoods.isNotEmpty)
            Container(
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
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '選択した食品 (${_selectedFoods.length}品)',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '合計: ${_getTotalCalories().toStringAsFixed(0)} kcal',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // 食事タイプ選択
                          Row(
                            children: [
                              _buildMealTypeChip('breakfast', '朝食', Icons.wb_sunny),
                              const SizedBox(width: 8),
                              _buildMealTypeChip('lunch', '昼食', Icons.wb_sunny_outlined),
                              const SizedBox(width: 8),
                              _buildMealTypeChip('dinner', '夕食', Icons.nights_stay),
                              const SizedBox(width: 8),
                              _buildMealTypeChip('snack', '間食', Icons.cookie),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveMeal,
                        style: ElevatedButton.styleFrom(
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
            ),
        ],
      ),
    );
  }
  
  Widget _buildFoodCard(Map<String, dynamic> food) {
    final isSelected = _selectedFoods.any((f) => f.name == food['name']);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isSelected ? 3 : 1,
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
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
              '${food['calories']}kcal',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
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
                Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _updateQuantity(food, -0.5),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Expanded(
                        child: Text(
                          _getQuantityText(food),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _updateQuantity(food, 0.5),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => _toggleFood(food),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => _toggleFood(food),
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }
  
  Widget _buildMealTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedMealType == type;
    
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : null),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedMealType = type;
          });
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
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
    setState(() {
      final existingIndex = _selectedFoods.indexWhere((f) => f.name == food['name']);
      
      if (existingIndex >= 0) {
        _selectedFoods.removeAt(existingIndex);
      } else {
        _selectedFoods.add(FoodItem(
          id: 'manual_${DateTime.now().millisecondsSinceEpoch}_${food['name'].hashCode}',
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
          ),
          confidenceScore: 1.0,
        ));
      }
    });
  }
  
  void _updateQuantity(Map<String, dynamic> food, double change) {
    setState(() {
      final index = _selectedFoods.indexWhere((f) => f.name == food['name']);
      if (index >= 0) {
        final currentFood = _selectedFoods[index];
        final newQuantity = (currentFood.quantity + change).clamp(0.5, 10.0);
        
        _selectedFoods[index] = FoodItem(
          id: currentFood.id,
          name: currentFood.name,
          quantity: newQuantity,
          unit: currentFood.unit,
          calories: food['calories'].toDouble() * newQuantity,
          nutritionInfo: NutritionInfo(
            protein: food['protein'].toDouble() * newQuantity,
            carbohydrates: food['carbs'].toDouble() * newQuantity,
            fat: food['fat'].toDouble() * newQuantity,
            fiber: 0.0,
            sugar: 0.0,
          ),
          confidenceScore: 1.0,
        );
      }
    });
  }
  
  String _getQuantityText(Map<String, dynamic> food) {
    final foodItem = _selectedFoods.firstWhere(
      (f) => f.name == food['name'],
      orElse: () => FoodItem(
        id: '',
        name: '',
        quantity: 1.0,
        unit: '',
        calories: 0,
        nutritionInfo: const NutritionInfo(
          protein: 0,
          carbohydrates: 0,
          fat: 0,
          fiber: 0,
          sugar: 0,
        ),
        confidenceScore: 0,
      ),
    );
    
    if (foodItem.quantity == 1.0) {
      return '1個';
    } else if (foodItem.quantity % 1 == 0) {
      return '${foodItem.quantity.toInt()}個';
    } else {
      return '${foodItem.quantity}個';
    }
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
  
  Future<void> _saveMeal() async {
    if (_selectedFoods.isEmpty) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // 手動入力用のダミー画像パスを作成
      final dummyImagePath = 'manual_entry_${DateTime.now().millisecondsSinceEpoch}';
      
      // 写真を保存（手動入力用のメタデータ）
      final savedPath = await _storageService.saveMealPhoto(
        originalPath: dummyImagePath,
        foodItems: _selectedFoods,
        totalCalories: _getTotalCalories(),
        mealType: _selectedMealType,
        isManualEntry: true,
      );
      
      // 食事記録を保存
      final mealRecord = MealRecord(
        id: const Uuid().v4(),
        recordedAt: DateTime.now(),
        mealType: _selectedMealType,
        foodItems: _selectedFoods,
        totalCalories: _getTotalCalories(),
        totalNutrition: _getTotalNutrition(),
        photoPath: savedPath,
        createdAt: DateTime.now(),
      );
      
      await _recordStorageService.saveMealRecord(mealRecord);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('食事を記録しました'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
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
    _quantityController.dispose();
    super.dispose();
  }
}