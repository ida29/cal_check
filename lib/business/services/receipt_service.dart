import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import 'food_translation_service.dart';

class ReceiptItem {
  final String name;
  final double? price;
  final int quantity;

  ReceiptItem({
    required this.name,
    this.price,
    this.quantity = 1,
  });
}

class ReceiptData {
  final String? storeName;
  final DateTime? dateTime;
  final List<ReceiptItem> items;
  final double? totalAmount;
  final String rawText;

  ReceiptData({
    this.storeName,
    this.dateTime,
    required this.items,
    this.totalAmount,
    required this.rawText,
  });
}

class ReceiptService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);
  final FoodTranslationService _translationService = FoodTranslationService();

  Future<ReceiptData?> scanReceipt(String imagePath) async {
    try {
      final inputImage = InputImage.fromFile(File(imagePath));
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      final receiptData = _parseReceiptText(recognizedText.text);
      return receiptData;
    } catch (e) {
      print('Error scanning receipt: $e');
      return null;
    }
  }

  ReceiptData _parseReceiptText(String text) {
    final lines = text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    
    String? storeName;
    DateTime? dateTime;
    List<ReceiptItem> items = [];
    double? totalAmount;

    // Extract store name (usually at the top)
    if (lines.isNotEmpty) {
      storeName = _extractStoreName(lines.take(3).toList());
    }

    // Extract date and time
    dateTime = _extractDateTime(lines);

    // Extract items and prices
    items = _extractItems(lines);

    // Extract total amount
    totalAmount = _extractTotalAmount(lines);

    return ReceiptData(
      storeName: storeName,
      dateTime: dateTime,
      items: items,
      totalAmount: totalAmount,
      rawText: text,
    );
  }

  String? _extractStoreName(List<String> topLines) {
    // Common patterns for store names in Japanese receipts
    for (final line in topLines) {
      if (line.contains('店') || line.contains('スーパー') || line.contains('コンビニ') ||
          line.contains('マート') || line.contains('ストア')) {
        return line.trim();
      }
    }
    return topLines.isNotEmpty ? topLines.first.trim() : null;
  }

  DateTime? _extractDateTime(List<String> lines) {
    final dateRegex = RegExp(r'(\d{4}[年/]\d{1,2}[月/]\d{1,2}[日]?)');
    final timeRegex = RegExp(r'(\d{1,2}[:時]\d{1,2}(?:[:分]\d{1,2})?)');
    
    String? dateStr;
    String? timeStr;

    for (final line in lines) {
      if (dateStr == null && dateRegex.hasMatch(line)) {
        dateStr = dateRegex.firstMatch(line)?.group(0);
      }
      if (timeStr == null && timeRegex.hasMatch(line)) {
        timeStr = timeRegex.firstMatch(line)?.group(0);
      }
      if (dateStr != null && timeStr != null) break;
    }

    // Try to parse the extracted date and time
    if (dateStr != null) {
      try {
        // Convert Japanese date format to parseable format
        final normalizedDate = dateStr
            .replaceAll('年', '-')
            .replaceAll('月', '-')
            .replaceAll('日', '');
        
        final parts = normalizedDate.split('-');
        if (parts.length >= 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          
          int hour = 0;
          int minute = 0;
          
          if (timeStr != null) {
            final timeParts = timeStr.replaceAll('時', ':').replaceAll('分', '').split(':');
            if (timeParts.isNotEmpty) hour = int.tryParse(timeParts[0]) ?? 0;
            if (timeParts.length > 1) minute = int.tryParse(timeParts[1]) ?? 0;
          }
          
          return DateTime(year, month, day, hour, minute);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
    
    return null;
  }

  List<ReceiptItem> _extractItems(List<String> lines) {
    final items = <ReceiptItem>[];
    final priceRegex = RegExp(r'[¥￥]\s*(\d{1,3}(?:,\d{3})*|\d+)');
    final quantityRegex = RegExp(r'(\d+)[個点]');
    
    for (final line in lines) {
      // Skip lines that likely contain totals or tax
      if (line.contains('合計') || line.contains('小計') || line.contains('税') ||
          line.contains('お預り') || line.contains('お釣り')) {
        continue;
      }
      
      // Check if line contains a price
      final priceMatch = priceRegex.firstMatch(line);
      if (priceMatch != null) {
        final priceStr = priceMatch.group(1)!.replaceAll(',', '');
        final price = double.tryParse(priceStr);
        
        if (price != null && price > 0) {
          // Extract item name (everything before the price)
          final itemName = line.substring(0, priceMatch.start).trim();
          
          // Skip if item name is empty or too short
          if (itemName.length > 1) {
            // Check for quantity
            int quantity = 1;
            final quantityMatch = quantityRegex.firstMatch(line);
            if (quantityMatch != null) {
              quantity = int.tryParse(quantityMatch.group(1)!) ?? 1;
            }
            
            items.add(ReceiptItem(
              name: itemName,
              price: price,
              quantity: quantity,
            ));
          }
        }
      }
    }
    
    return items;
  }

  double? _extractTotalAmount(List<String> lines) {
    final totalRegex = RegExp(r'(?:合計|小計|計)\s*[¥￥]?\s*(\d{1,3}(?:,\d{3})*|\d+)');
    
    for (final line in lines.reversed) {
      final match = totalRegex.firstMatch(line);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        return double.tryParse(amountStr);
      }
    }
    
    return null;
  }

  Future<List<FoodItem>> convertReceiptItemsToFoodItems(List<ReceiptItem> receiptItems) async {
    final foodItems = <FoodItem>[];
    
    for (final item in receiptItems) {
      // Translate Japanese food name to English for better nutrition lookup
      final translatedName = await _translationService.translateFood(item.name);
      
      // Create a basic FoodItem with estimated nutrition
      // In a real implementation, you might want to look up nutrition info from a database
      final foodItem = FoodItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: item.name,
        brand: null,
        barcode: null,
        calories: _estimateCalories(translatedName ?? item.name),
        nutrition: _estimateNutrition(translatedName ?? item.name),
        weight: 100, // Default weight in grams
        imageUrl: null,
      );
      
      foodItems.add(foodItem);
    }
    
    return foodItems;
  }

  // Basic calorie estimation based on common food categories
  double _estimateCalories(String foodName) {
    final lowerName = foodName.toLowerCase();
    
    // Vegetables
    if (_containsAny(lowerName, ['vegetable', 'salad', '野菜', 'サラダ'])) {
      return 25.0;
    }
    // Fruits
    else if (_containsAny(lowerName, ['fruit', 'apple', 'banana', 'フルーツ', 'りんご', 'バナナ'])) {
      return 60.0;
    }
    // Meat
    else if (_containsAny(lowerName, ['meat', 'chicken', 'beef', 'pork', '肉', '鶏', '牛', '豚'])) {
      return 250.0;
    }
    // Fish
    else if (_containsAny(lowerName, ['fish', 'salmon', 'tuna', '魚', 'サーモン', 'マグロ'])) {
      return 150.0;
    }
    // Rice/Bread
    else if (_containsAny(lowerName, ['rice', 'bread', 'pasta', 'ご飯', 'パン', 'パスタ'])) {
      return 200.0;
    }
    // Snacks
    else if (_containsAny(lowerName, ['snack', 'chip', 'cookie', 'スナック', 'チップ', 'クッキー'])) {
      return 150.0;
    }
    // Drinks
    else if (_containsAny(lowerName, ['drink', 'juice', 'soda', '飲み物', 'ジュース', 'ソーダ'])) {
      return 45.0;
    }
    // Default
    return 100.0;
  }

  NutritionInfo _estimateNutrition(String foodName) {
    final lowerName = foodName.toLowerCase();
    
    // Basic nutrition estimation based on food categories
    if (_containsAny(lowerName, ['vegetable', 'salad', '野菜', 'サラダ'])) {
      return NutritionInfo(protein: 1.0, carbs: 5.0, fat: 0.2, fiber: 2.0, sugar: 2.0);
    } else if (_containsAny(lowerName, ['meat', 'chicken', 'beef', '肉', '鶏', '牛'])) {
      return NutritionInfo(protein: 20.0, carbs: 0.0, fat: 15.0, fiber: 0.0, sugar: 0.0);
    } else if (_containsAny(lowerName, ['rice', 'bread', 'pasta', 'ご飯', 'パン', 'パスタ'])) {
      return NutritionInfo(protein: 3.0, carbs: 40.0, fat: 1.0, fiber: 2.0, sugar: 1.0);
    }
    
    // Default balanced nutrition
    return NutritionInfo(protein: 5.0, carbs: 15.0, fat: 5.0, fiber: 1.0, sugar: 3.0);
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  void dispose() {
    textRecognizer.close();
  }
}