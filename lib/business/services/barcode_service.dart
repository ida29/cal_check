import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import 'food_translation_service.dart';

class BarcodeService {
  static final BarcodeService _instance = BarcodeService._internal();
  factory BarcodeService() => _instance;
  BarcodeService._internal();

  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  final Dio _dio = Dio();
  final FoodTranslationService _translationService = FoodTranslationService();

  /// 画像からバーコードをスキャンする
  Future<List<Barcode>> scanBarcode(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final barcodes = await _barcodeScanner.processImage(inputImage);
      return barcodes;
    } catch (e) {
      print('Error scanning barcode: $e');
      return [];
    }
  }

  /// バーコードから商品情報を取得する
  Future<FoodItem?> getProductInfo(String barcode) async {
    try {
      // OpenFoodFacts APIを使用して商品情報を取得
      final response = await _dio.get(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
        options: Options(
          headers: {
            'User-Agent': 'CalorieCheckerAI/1.0 (Contact: your-email@example.com)',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 1 && data['product'] != null) {
          return _parseProductData(data['product'], barcode);
        }
      }
      
      // データが見つからない場合は手動入力用のプレースホルダーを返す
      return _createPlaceholderItem(barcode);
    } catch (e) {
      print('Error fetching product info: $e');
      return _createPlaceholderItem(barcode);
    }
  }

  /// OpenFoodFactsの商品データをFoodItemに変換
  FoodItem _parseProductData(Map<String, dynamic> product, String barcode) {
    // 商品名の取得と翻訳
    String productName = product['product_name'] ?? 
                        product['product_name_en'] ?? 
                        product['product_name_ja'] ?? 
                        'Unknown Product';
    
    final translatedName = _translationService.translateFoodName(productName);

    // 栄養成分情報の取得 (100gあたり)
    final nutriments = product['nutriments'] ?? {};
    
    final calories = _parseNutrient(nutriments['energy-kcal_100g']) ?? 
                    _parseNutrient(nutriments['energy_100g']) ?? 0.0;
    
    final protein = _parseNutrient(nutriments['proteins_100g']) ?? 0.0;
    final carbs = _parseNutrient(nutriments['carbohydrates_100g']) ?? 0.0;
    final fat = _parseNutrient(nutriments['fat_100g']) ?? 0.0;
    final fiber = _parseNutrient(nutriments['fiber_100g']) ?? 0.0;
    final sugar = _parseNutrient(nutriments['sugars_100g']) ?? 0.0;
    final sodium = _parseNutrient(nutriments['sodium_100g']) ?? 0.0;

    // 商品サイズの推定（グラム単位）
    double estimatedWeight = 100.0; // デフォルト
    final quantity = product['quantity'] ?? '';
    if (quantity.isNotEmpty) {
      estimatedWeight = _parseQuantity(quantity);
    }

    return FoodItem(
      id: 'barcode_${DateTime.now().millisecondsSinceEpoch}_$barcode',
      name: translatedName,
      quantity: estimatedWeight,
      unit: 'g',
      calories: (calories * estimatedWeight / 100).roundToDouble(),
      nutritionInfo: NutritionInfo(
        protein: (protein * estimatedWeight / 100).roundToDouble(),
        carbohydrates: (carbs * estimatedWeight / 100).roundToDouble(),
        fat: (fat * estimatedWeight / 100).roundToDouble(),
        fiber: (fiber * estimatedWeight / 100).roundToDouble(),
        sugar: (sugar * estimatedWeight / 100).roundToDouble(),
      ),
      confidenceScore: 1.0,
    );
  }

  /// プレースホルダーアイテムを作成（商品が見つからない場合）
  FoodItem _createPlaceholderItem(String barcode) {
    return FoodItem(
      id: 'barcode_placeholder_${DateTime.now().millisecondsSinceEpoch}_$barcode',
      name: 'バーコード商品',
      quantity: 100.0,
      unit: 'g',
      calories: 0.0,
      nutritionInfo: const NutritionInfo(
        protein: 0.0,
        carbohydrates: 0.0,
        fat: 0.0,
        fiber: 0.0,
        sugar: 0.0,
      ),
      confidenceScore: 0.0,
    );
  }

  /// 栄養成分の数値を安全にパース
  double? _parseNutrient(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// 商品の量から重量を推定
  double _parseQuantity(String quantity) {
    // 一般的な単位を解析
    final cleanQuantity = quantity.toLowerCase().replaceAll(RegExp(r'[^\d\.,]'), '');
    final number = double.tryParse(cleanQuantity.replaceAll(',', '.')) ?? 100.0;
    
    if (quantity.contains('kg')) {
      return number * 1000; // kgをgに変換
    } else if (quantity.contains('ml') || quantity.contains('l')) {
      if (quantity.contains('l') && !quantity.contains('ml')) {
        return number * 1000; // リットルをmlに変換
      }
      return number; // 液体の場合、mlをgと同等とみなす
    } else if (quantity.contains('g')) {
      return number;
    } else {
      // 単位が不明な場合、数値に基づいて推定
      if (number < 10) {
        return number * 1000; // おそらくkg
      } else if (number > 1000) {
        return number; // おそらくml
      }
      return number; // おそらくg
    }
  }

  /// リソースの解放
  void dispose() {
    _barcodeScanner.close();
  }
}