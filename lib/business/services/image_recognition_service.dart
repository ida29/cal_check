import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../models/recognition_result.dart';

class ImageRecognitionService {
  static final ImageRecognitionService _instance = ImageRecognitionService._internal();
  factory ImageRecognitionService() => _instance;
  ImageRecognitionService._internal();

  ImageLabeler? _imageLabeler;

  Future<void> initialize() async {
    try {
      final options = ImageLabelerOptions(
        confidenceThreshold: 0.5,
      );
      _imageLabeler = ImageLabeler(options: options);
    } catch (e) {
      print('Error initializing image recognition: $e');
    }
  }

  Future<RecognitionResult> recognizeFood(String imagePath) async {
    try {
      if (_imageLabeler == null) {
        await initialize();
      }

      final inputImage = InputImage.fromFilePath(imagePath);
      final labels = await _imageLabeler!.processImage(inputImage);

      final foodItems = <FoodItem>[];
      final foodLabels = labels.where((label) => _isFoodLabel(label.label)).toList();

      for (final label in foodLabels) {
        final foodItem = await _createFoodItemFromLabel(label);
        if (foodItem != null) {
          foodItems.add(foodItem);
        }
      }

      final overallConfidence = foodItems.isNotEmpty
          ? foodItems.map((item) => item.confidenceScore).reduce((a, b) => a + b) / foodItems.length
          : 0.0;

      return RecognitionResult(
        imagePath: imagePath,
        detectedItems: foodItems,
        overallConfidence: overallConfidence,
        timestamp: DateTime.now(),
        requiresManualReview: overallConfidence < 0.7 || foodItems.isEmpty,
      );
    } catch (e) {
      print('Error recognizing food: $e');
      return RecognitionResult(
        imagePath: imagePath,
        detectedItems: [],
        overallConfidence: 0.0,
        timestamp: DateTime.now(),
        requiresManualReview: true,
        errorMessage: e.toString(),
      );
    }
  }

  bool _isFoodLabel(String label) {
    final foodKeywords = [
      'food', 'meal', 'dish', 'fruit', 'vegetable', 'meat', 'fish', 'chicken',
      'beef', 'pork', 'bread', 'rice', 'pasta', 'salad', 'soup', 'sandwich',
      'pizza', 'burger', 'apple', 'banana', 'orange', 'tomato', 'potato',
      'carrot', 'broccoli', 'cheese', 'milk', 'egg', 'yogurt', 'cereal',
      'cookie', 'cake', 'pie', 'ice cream', 'chocolate', 'candy', 'nut',
      'bean', 'grain', 'berry', 'seafood', 'poultry', 'dairy', 'beverage',
      'drink', 'juice', 'coffee', 'tea', 'wine', 'beer', 'water'
    ];

    return foodKeywords.any((keyword) => 
        label.toLowerCase().contains(keyword.toLowerCase()));
  }

  Future<FoodItem?> _createFoodItemFromLabel(ImageLabel label) async {
    try {
      final nutritionInfo = _getNutritionInfo(label.label);
      
      return FoodItem(
        id: 'detected_${DateTime.now().millisecondsSinceEpoch}_${label.label.hashCode}',
        name: _formatFoodName(label.label),
        quantity: _estimateQuantity(label.label),
        unit: _getUnit(label.label),
        calories: _estimateCalories(label.label),
        nutritionInfo: nutritionInfo,
        confidenceScore: label.confidence,
      );
    } catch (e) {
      print('Error creating food item from label: $e');
      return null;
    }
  }

  String _formatFoodName(String label) {
    return label.split(' ').map((word) => 
        word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  double _estimateQuantity(String foodName) {
    final foodName_ = foodName.toLowerCase();
    
    if (foodName_.contains('fruit') || foodName_.contains('apple') || 
        foodName_.contains('banana') || foodName_.contains('orange')) {
      return 1.0;
    } else if (foodName_.contains('rice') || foodName_.contains('pasta')) {
      return 150.0;
    } else if (foodName_.contains('meat') || foodName_.contains('chicken') || 
               foodName_.contains('fish')) {
      return 100.0;
    } else if (foodName_.contains('vegetable') || foodName_.contains('salad')) {
      return 80.0;
    } else {
      return 100.0;
    }
  }

  String _getUnit(String foodName) {
    final foodName_ = foodName.toLowerCase();
    
    if (foodName_.contains('fruit') || foodName_.contains('apple') || 
        foodName_.contains('banana') || foodName_.contains('orange')) {
      return 'piece';
    } else {
      return 'g';
    }
  }

  double _estimateCalories(String foodName) {
    final calorieMap = {
      'apple': 52,
      'banana': 89,
      'orange': 47,
      'rice': 130,
      'chicken': 165,
      'beef': 250,
      'fish': 150,
      'bread': 265,
      'pasta': 131,
      'potato': 77,
      'broccoli': 34,
      'carrot': 41,
      'tomato': 18,
      'cheese': 402,
      'egg': 155,
      'milk': 42,
    };

    final foodName_ = foodName.toLowerCase();
    
    for (final entry in calorieMap.entries) {
      if (foodName_.contains(entry.key)) {
        final quantity = _estimateQuantity(foodName);
        final unit = _getUnit(foodName);
        
        if (unit == 'piece') {
          if (entry.key == 'apple') return entry.value * 1.8; // ~182g average
          if (entry.key == 'banana') return entry.value * 1.2; // ~120g average
          if (entry.key == 'orange') return entry.value * 1.5; // ~150g average
          return entry.value.toDouble();
        } else {
          return (entry.value * quantity / 100).roundToDouble();
        }
      }
    }
    
    return 100.0;
  }

  NutritionInfo _getNutritionInfo(String foodName) {
    final nutritionMap = {
      'apple': NutritionInfo(protein: 0.3, carbohydrates: 13.8, fat: 0.2, fiber: 2.4, sugar: 10.4),
      'banana': NutritionInfo(protein: 1.1, carbohydrates: 22.8, fat: 0.3, fiber: 2.6, sugar: 12.2),
      'orange': NutritionInfo(protein: 0.9, carbohydrates: 11.8, fat: 0.1, fiber: 2.4, sugar: 9.4),
      'rice': NutritionInfo(protein: 2.7, carbohydrates: 28.2, fat: 0.3, fiber: 0.4),
      'chicken': NutritionInfo(protein: 31.0, carbohydrates: 0.0, fat: 3.6),
      'beef': NutritionInfo(protein: 26.0, carbohydrates: 0.0, fat: 17.0),
      'fish': NutritionInfo(protein: 22.0, carbohydrates: 0.0, fat: 5.0),
      'bread': NutritionInfo(protein: 9.0, carbohydrates: 49.0, fat: 3.2, fiber: 2.7),
      'broccoli': NutritionInfo(protein: 2.8, carbohydrates: 6.6, fat: 0.4, fiber: 2.6),
      'egg': NutritionInfo(protein: 12.6, carbohydrates: 1.1, fat: 10.6),
    };

    final foodName_ = foodName.toLowerCase();
    
    for (final entry in nutritionMap.entries) {
      if (foodName_.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return const NutritionInfo(protein: 5.0, carbohydrates: 15.0, fat: 3.0);
  }

  Future<void> dispose() async {
    await _imageLabeler?.close();
    _imageLabeler = null;
  }
}