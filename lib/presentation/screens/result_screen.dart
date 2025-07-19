import 'package:flutter/material.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../../business/services/ai_calorie_service.dart';
import '../../business/services/barcode_service.dart';
import '../../business/services/local_photo_storage_service.dart';
import '../../business/models/recognition_result.dart';
import '../../data/entities/food_item.dart';
import '../widgets/food_name_display.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String imagePath;
  late String mode;
  bool _isAnalyzing = true;
  RecognitionResult? _recognitionResult;
  List<FoodItem> _foodItems = [];
  String? _errorMessage;
  bool _isSaving = false;
  bool _isSaved = false;

  final AICalorieService _aiService = AICalorieService();
  final BarcodeService _barcodeService = BarcodeService();
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
      });
    } else {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.productInfoRetrievalFailed;
        _isAnalyzing = false;
      });
    }
  }

  double get _totalCalories {
    return _aiService.getTotalCalories(_foodItems);
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
                  '${item.calories.toStringAsFixed(0)} cal',
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
                TextButton(
                  onPressed: () => _removeItem(item),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text(AppLocalizations.of(context)!.remove),
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
    });
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

      final savedPath = await _storageService.saveMealPhoto(
        originalPath: imagePath,
        foodItems: _foodItems,
        totalCalories: _totalCalories,
        mealType: mealType,
      );

      if (savedPath != null) {
        setState(() {
          _isSaved = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.mealSavedSuccessfully),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
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