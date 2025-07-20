import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../../business/services/ai_calorie_service.dart';
import '../../business/services/barcode_service.dart';
import '../../business/services/receipt_service.dart';
import '../../business/services/local_photo_storage_service.dart';
import '../../business/models/recognition_result.dart';
import '../../business/providers/meal_provider.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/nutrition_info.dart';
import '../widgets/food_name_display.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late String imagePath;
  late String mode;
  bool _isAnalyzing = true;
  RecognitionResult? _recognitionResult;
  List<FoodItem> _foodItems = [];
  String? _errorMessage;
  bool _isSaving = false;
  bool _isSaved = false;
  DateTime _selectedDate = DateTime.now();
  Map<String, int> _itemQuantities = {};

  final AICalorieService _aiService = AICalorieService();
  final BarcodeService _barcodeService = BarcodeService();
  final ReceiptService _receiptService = ReceiptService();
  final LocalPhotoStorageService _storageService = LocalPhotoStorageService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    imagePath = args?['imagePath'] ?? '';
    mode = args?['mode'] ?? 'food';
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    try {
      setState(() {
        _isAnalyzing = true;
        _errorMessage = null;
      });

      if (mode == 'barcode') {
        await _analyzeBarcodeImage();
      } else if (mode == 'receipt') {
        await _analyzeReceiptImage();
      } else {
        await _analyzeFoodImage();
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${AppLocalizations.of(context)!.errorOccurred}: $e';
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _analyzeFoodImage() async {
    final result = await _aiService.analyzeFood(imagePath);
    
    setState(() {
      _recognitionResult = result;
      _foodItems = List.from(result.detectedItems);
      _isAnalyzing = false;
      // 初期個数を1に設定
      _itemQuantities = {
        for (var item in result.detectedItems) item.name: 1
      };
    });
  }

  Future<void> _analyzeBarcodeImage() async {
    final barcodes = await _barcodeService.scanBarcode(imagePath);
    
    if (barcodes.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.barcodeNotDetected;
        _isAnalyzing = false;
      });
      return;
    }

    final barcode = barcodes.first;
    final barcodeValue = barcode.displayValue ?? '';
    
    if (barcodeValue.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.barcodeReadingFailed;
        _isAnalyzing = false;
      });
      return;
    }

    final foodItem = await _barcodeService.getProductInfo(barcodeValue);
    
    if (foodItem != null) {
      setState(() {
        _foodItems = [foodItem];
        _isAnalyzing = false;
        // 初期個数を1に設定
        _itemQuantities = {foodItem.name: 1};
      });
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.productInfoRetrievalFailed;
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _analyzeReceiptImage() async {
    final receiptData = await _receiptService.scanReceipt(imagePath);
    
    if (receiptData == null || receiptData.items.isEmpty) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.receiptNotDetected;
        _isAnalyzing = false;
      });
      return;
    }

    // Convert receipt items to food items
    final foodItems = await _receiptService.convertReceiptItemsToFoodItems(receiptData.items);
    
    setState(() {
      _foodItems = foodItems;
      _isAnalyzing = false;
      // 初期個数を1に設定
      _itemQuantities = {
        for (var item in foodItems) item.name: 1
      };
    });
  }

  double get _totalCalories {
    double total = 0;
    for (var item in _foodItems) {
      final quantity = _itemQuantities[item.name] ?? 1;
      total += item.calories * quantity;
    }
    return total;
  }

  Widget _buildDateSelector() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFFFF69B4)),
            const SizedBox(width: 12),
            Text(
              '記録日時',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF69B4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFF69B4)),
                ),
                child: Text(
                  '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                  style: const TextStyle(
                    color: Color(0xFFFF69B4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.analysisResults),
        actions: [
          if (!_isAnalyzing && !_isSaved)
            TextButton(
              onPressed: _isSaving ? null : _saveMealToHistory,
              child: _isSaving 
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(AppLocalizations.of(context)!.save),
            ),
          if (_isSaved)
            const Icon(Icons.check, color: Colors.green),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              color: Colors.black,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            if (_isAnalyzing)
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(mode == 'barcode' 
                        ? AppLocalizations.of(context)!.analyzingBarcode 
                        : AppLocalizations.of(context)!.analyzingMeal),
                    ],
                  ),
                ),
              )
            else if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.red.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)!.analysisFailed,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(_errorMessage!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _analyzeImage,
                          child: Text(AppLocalizations.of(context)!.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSelector(),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.totalCalories,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_totalCalories.toStringAsFixed(0)} cal',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNutritionSummary(),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.detectedItems,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ..._foodItems.map((item) => _buildFoodItemCard(item)),
                    const SizedBox(height: 20),
                    if (!_isSaved) ...[
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveMealToHistory,
                        icon: _isSaving 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                        label: Text(_isSaving 
                          ? AppLocalizations.of(context)!.saving 
                          : AppLocalizations.of(context)!.saveToMealHistory),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_isSaved) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.mealSavedSuccessfully,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ElevatedButton.icon(
                      onPressed: _addCustomItem,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.addItem),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: _isSaved ? Colors.grey : null,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodItemCard(FoodItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FoodNameDisplay(
                    foodName: item.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    showOriginal: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Chip(
                  label: Text(
                    '${(item.confidenceScore * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getConfidenceColor(item.confidenceScore),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.quantity.toStringAsFixed(0)} ${item.unit}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${(item.calories * (_itemQuantities[item.name] ?? 1)).toStringAsFixed(0)} cal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _editItem(item),
                  child: Text(AppLocalizations.of(context)!.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green.withOpacity(0.2);
    if (confidence >= 0.6) return Colors.orange.withOpacity(0.2);
    return Colors.red.withOpacity(0.2);
  }

  void _editItem(FoodItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.editComingSoon)),
    );
  }

  void _removeItem(FoodItem item) {
    setState(() {
      _foodItems.remove(item);
      _itemQuantities.remove(item.name);
    });
  }

  void _updateQuantity(String itemName, int change) {
    setState(() {
      final currentQuantity = _itemQuantities[itemName] ?? 1;
      final newQuantity = (currentQuantity + change).clamp(1, 99);
      _itemQuantities[itemName] = newQuantity;
    });
  }

  void _showSaveSuccessModal() {
    showDialog(
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
          content: const Text('食事の記録が保存されました。\n追加で記録しますか？'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                Navigator.of(context).pop(); // 結果画面を閉じる
              },
              child: const Text('記録を終了'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                Navigator.of(context).pop(); // 結果画面を閉じる
                Navigator.pushNamed(context, '/camera'); // カメラ画面に戻る
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                foregroundColor: Colors.white,
              ),
              child: const Text('追加で記録'),
            ),
          ],
        );
      },
    );
  }

  void _addCustomItem() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.addCustomItemComingSoon)),
    );
  }

  Widget _buildNutritionSummary() {
    if (_foodItems.isEmpty) return const SizedBox.shrink();
    
    final totalNutrition = _aiService.getTotalNutrition(_foodItems);
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.nutritionSummary,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNutritionItem(
                  AppLocalizations.of(context)!.protein,
                  '${totalNutrition.protein.toStringAsFixed(1)}g',
                  Colors.red,
                ),
                _buildNutritionItem(
                  AppLocalizations.of(context)!.carbs,
                  '${totalNutrition.carbohydrates.toStringAsFixed(1)}g',
                  Colors.orange,
                ),
                _buildNutritionItem(
                  AppLocalizations.of(context)!.fat,
                  '${totalNutrition.fat.toStringAsFixed(1)}g',
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Future<void> _saveMealToHistory() async {
    if (_foodItems.isEmpty || _isSaving || _isSaved) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Determine meal type based on current time
      final now = DateTime.now();
      final hour = now.hour;
      String mealType;
      
      if (hour < 11) {
        mealType = 'breakfast';
      } else if (hour < 15) {
        mealType = 'lunch';
      } else if (hour < 21) {
        mealType = 'dinner';
      } else {
        mealType = 'snack';
      }

      // Apply quantities to food items
      final adjustedFoodItems = _foodItems.map((item) {
        final quantity = _itemQuantities[item.name] ?? 1;
        return FoodItem(
          id: item.id,
          name: item.name,
          quantity: item.quantity * quantity,
          unit: item.unit,
          calories: item.calories * quantity,
          nutritionInfo: NutritionInfo(
            protein: item.nutritionInfo.protein * quantity,
            carbohydrates: item.nutritionInfo.carbohydrates * quantity,
            fat: item.nutritionInfo.fat * quantity,
            fiber: item.nutritionInfo.fiber * quantity,
            sugar: item.nutritionInfo.sugar * quantity,
            sodium: item.nutritionInfo.sodium * quantity,
          ),
          confidenceScore: item.confidenceScore,
        );
      }).toList();

      final savedPath = await _storageService.saveMealPhoto(
        originalPath: imagePath,
        foodItems: adjustedFoodItems,
        totalCalories: _totalCalories,
        mealType: mealType,
        createdAt: _selectedDate,
      );

      if (savedPath != null) {
        // Calculate total nutrition
        final totalNutrition = adjustedFoodItems.fold(
          const NutritionInfo(
            protein: 0,
            carbohydrates: 0,
            fat: 0,
            fiber: 0,
            sugar: 0,
            sodium: 0,
          ),
          (prev, item) => NutritionInfo(
            protein: prev.protein + item.nutritionInfo.protein,
            carbohydrates: prev.carbohydrates + item.nutritionInfo.carbohydrates,
            fat: prev.fat + item.nutritionInfo.fat,
            fiber: prev.fiber + item.nutritionInfo.fiber,
            sugar: prev.sugar + item.nutritionInfo.sugar,
            sodium: prev.sodium + item.nutritionInfo.sodium,
          ),
        );

        // Create meal object and save to database
        final meal = Meal(
          id: const Uuid().v4(),
          timestamp: _selectedDate,
          mealType: MealType.values.firstWhere(
            (e) => e.toString().split('.').last == mealType,
          ),
          imagePath: savedPath,
          foodItems: adjustedFoodItems,
          totalCalories: _totalCalories,
          totalNutrition: totalNutrition,
          isManualEntry: false,
        );

        // Save to meal database
        await ref.read(mealsProvider.notifier).saveMeal(meal);

        setState(() {
          _isSaved = true;
        });
        
        // 保存成功後にモーダルを表示
        _showSaveSuccessModal();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.failedToSaveMeal),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving meal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save meal. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }
}