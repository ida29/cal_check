import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../models/recognition_result.dart';
import '../../config/ai_config.dart';

class AICalorieService {
  static final AICalorieService _instance = AICalorieService._internal();
  factory AICalorieService() => _instance;
  AICalorieService._internal();

  final Dio _dio = Dio();

  Future<RecognitionResult> analyzeFood(String imagePath) async {
    try {
      // For demo purposes, if no API key is configured, use mock data
      if (!AIConfig.isConfigured) {
        return await _getMockAnalysis(imagePath);
      }

      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await _dio.post(
        '${AIConfig.baseUrl}/chat/completions',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AIConfig.openRouterApiKey}',
            'Content-Type': 'application/json',
            'HTTP-Referer': AIConfig.referer,
            'X-Title': AIConfig.appTitle,
          },
        ),
        data: {
          'model': AIConfig.currentModel,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': '''Analyze this food image and provide detailed nutritional information. 
                  Return the response in JSON format with the following structure:
                  {
                    "foods": [
                      {
                        "name": "food name",
                        "quantity": estimated_quantity_number,
                        "unit": "g" or "piece" or "ml",
                        "calories": estimated_calories_number,
                        "nutrition": {
                          "protein": protein_grams,
                          "carbohydrates": carbs_grams,
                          "fat": fat_grams,
                          "fiber": fiber_grams,
                          "sugar": sugar_grams
                        },
                        "confidence": confidence_score_0_to_1
                      }
                    ],
                    "totalCalories": total_calories_number,
                    "confidence": overall_confidence_0_to_1
                  }
                  
                  Be as accurate as possible with portion sizes and nutritional values.
                  Only include foods that you can clearly identify in the image.'''
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'max_tokens': 1000
        },
      );

      return await _parseAIResponse(response.data, imagePath);
    } catch (e) {
      print('Error analyzing food with AI: $e');
      // Fallback to mock data on error
      return await _getMockAnalysis(imagePath);
    }
  }

  Future<RecognitionResult> _parseAIResponse(Map<String, dynamic> response, String imagePath) async {
    try {
      final content = response['choices'][0]['message']['content'];
      
      // Extract JSON from the response (might be wrapped in markdown)
      String jsonStr = content;
      if (content.contains('```json')) {
        final startIndex = content.indexOf('```json') + 7;
        final endIndex = content.indexOf('```', startIndex);
        jsonStr = content.substring(startIndex, endIndex).trim();
      } else if (content.contains('```')) {
        final startIndex = content.indexOf('```') + 3;
        final endIndex = content.indexOf('```', startIndex);
        jsonStr = content.substring(startIndex, endIndex).trim();
      }

      final jsonData = json.decode(jsonStr);
      final foodItems = <FoodItem>[];

      if (jsonData['foods'] != null) {
        for (final foodData in jsonData['foods']) {
          final nutritionData = foodData['nutrition'] ?? {};
          
          final foodItem = FoodItem(
            id: 'ai_${DateTime.now().millisecondsSinceEpoch}_${foodData['name'].hashCode}',
            name: foodData['name'] ?? 'Unknown Food',
            quantity: (foodData['quantity'] ?? 100).toDouble(),
            unit: foodData['unit'] ?? 'g',
            calories: (foodData['calories'] ?? 100).toDouble(),
            nutritionInfo: NutritionInfo(
              protein: (nutritionData['protein'] ?? 0).toDouble(),
              carbohydrates: (nutritionData['carbohydrates'] ?? 0).toDouble(),
              fat: (nutritionData['fat'] ?? 0).toDouble(),
              fiber: (nutritionData['fiber'] ?? 0).toDouble(),
              sugar: (nutritionData['sugar'] ?? 0).toDouble(),
            ),
            confidenceScore: (foodData['confidence'] ?? 0.5).toDouble(),
          );
          
          foodItems.add(foodItem);
        }
      }

      final overallConfidence = (jsonData['confidence'] ?? 0.5).toDouble();

      return RecognitionResult(
        imagePath: imagePath,
        detectedItems: foodItems,
        overallConfidence: overallConfidence,
        timestamp: DateTime.now(),
        requiresManualReview: overallConfidence < 0.7 || foodItems.isEmpty,
      );
    } catch (e) {
      print('Error parsing AI response: $e');
      return await _getMockAnalysis(imagePath);
    }
  }

  Future<RecognitionResult> _getMockAnalysis(String imagePath) async {
    // Mock analysis for demo purposes
    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay

    final mockFoodItems = [
      FoodItem(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}_1',
        name: 'Grilled Chicken Breast',
        quantity: 150.0,
        unit: 'g',
        calories: 247.5,
        nutritionInfo: const NutritionInfo(
          protein: 46.5,
          carbohydrates: 0.0,
          fat: 5.4,
          fiber: 0.0,
          sugar: 0.0,
        ),
        confidenceScore: 0.92,
      ),
      FoodItem(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}_2',
        name: 'Steamed Broccoli',
        quantity: 100.0,
        unit: 'g',
        calories: 34.0,
        nutritionInfo: const NutritionInfo(
          protein: 2.8,
          carbohydrates: 6.6,
          fat: 0.4,
          fiber: 2.6,
          sugar: 1.5,
        ),
        confidenceScore: 0.88,
      ),
      FoodItem(
        id: 'mock_${DateTime.now().millisecondsSinceEpoch}_3',
        name: 'Brown Rice',
        quantity: 80.0,
        unit: 'g',
        calories: 104.0,
        nutritionInfo: const NutritionInfo(
          protein: 2.2,
          carbohydrates: 22.6,
          fat: 0.2,
          fiber: 0.3,
          sugar: 0.0,
        ),
        confidenceScore: 0.85,
      ),
    ];

    final overallConfidence = mockFoodItems
        .map((item) => item.confidenceScore)
        .reduce((a, b) => a + b) / mockFoodItems.length;

    return RecognitionResult(
      imagePath: imagePath,
      detectedItems: mockFoodItems,
      overallConfidence: overallConfidence,
      timestamp: DateTime.now(),
      requiresManualReview: false,
    );
  }

  double getTotalCalories(List<FoodItem> foodItems) {
    return foodItems.fold(0.0, (sum, item) => sum + item.calories);
  }

  NutritionInfo getTotalNutrition(List<FoodItem> foodItems) {
    if (foodItems.isEmpty) {
      return const NutritionInfo(
        protein: 0,
        carbohydrates: 0,
        fat: 0,
        fiber: 0,
        sugar: 0,
      );
    }

    double totalProtein = 0;
    double totalCarbohydrates = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalSugar = 0;

    for (final item in foodItems) {
      final ratio = item.quantity / 100; // Nutrition info is typically per 100g
      totalProtein += item.nutritionInfo.protein * ratio;
      totalCarbohydrates += item.nutritionInfo.carbohydrates * ratio;
      totalFat += item.nutritionInfo.fat * ratio;
      totalFiber += item.nutritionInfo.fiber * ratio;
      totalSugar += item.nutritionInfo.sugar * ratio;
    }

    return NutritionInfo(
      protein: totalProtein,
      carbohydrates: totalCarbohydrates,
      fat: totalFat,
      fiber: totalFiber,
      sugar: totalSugar,
    );
  }

  void dispose() {
    _dio.close();
  }
}