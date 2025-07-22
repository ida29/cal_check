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
    // 複数のAPIを順番に試す
    FoodItem? result;
    
    // 1. OpenFoodFacts (世界のデータベース)
    result = await _tryOpenFoodFacts(barcode);
    if (result != null && result.name != 'バーコード商品') {
      return result;
    }
    
    // 2. FoodData Central (USDAのデータベース)
    result = await _tryFoodDataCentral(barcode);
    if (result != null && result.name != 'バーコード商品') {
      return result;
    }
    
    // 3. 日本商品データベース (簡易版)
    result = await _tryJapanProductDatabase(barcode);
    if (result != null && result.name != 'バーコード商品') {
      return result;
    }
    
    // すべて失敗した場合はプレースホルダーを返す
    return _createPlaceholderItem(barcode);
  }

  /// OpenFoodFacts APIで商品情報を取得
  Future<FoodItem?> _tryOpenFoodFacts(String barcode) async {
    try {
      final response = await _dio.get(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json',
        options: Options(
          headers: {
            'User-Agent': 'CalorieCheckerAI/1.0 (Contact: your-email@example.com)',
          },
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data['status'] == 1 && data['product'] != null) {
          return _parseProductData(data['product'], barcode);
        }
      }
    } catch (e) {
      print('OpenFoodFacts API error: $e');
    }
    
    return null;
  }

  /// FoodData Central APIで商品情報を取得 (代替API)
  Future<FoodItem?> _tryFoodDataCentral(String barcode) async {
    try {
      // FoodData Central APIは主にUPC/EANコードをサポート
      // ここでは簡易的な実装
      print('FoodData Central API は現在未実装');
      return null;
    } catch (e) {
      print('FoodData Central API error: $e');
      return null;
    }
  }

  /// 日本商品データベース (簡易版)
  Future<FoodItem?> _tryJapanProductDatabase(String barcode) async {
    try {
      // 日本の代表的な商品のハードコードデータベース
      final japaneseProducts = _getJapaneseProductDatabase();
      
      if (japaneseProducts.containsKey(barcode)) {
        final productData = japaneseProducts[barcode]!;
        return FoodItem(
          id: 'jp_product_${DateTime.now().millisecondsSinceEpoch}_$barcode',
          name: productData['name'],
          quantity: productData['quantity'],
          unit: productData['unit'],
          calories: productData['calories'],
          nutritionInfo: NutritionInfo(
            protein: productData['protein'],
            carbohydrates: productData['carbohydrates'],
            fat: productData['fat'],
            fiber: productData['fiber'],
            sugar: productData['sugar'],
            sodium: productData['sodium'],
          ),
          confidenceScore: 1.0,
        );
      }
    } catch (e) {
      print('Japan product database error: $e');
    }
    
    return null;
  }

  /// 日本商品の簡易データベース
  Map<String, Map<String, dynamic>> _getJapaneseProductDatabase() {
    return {
      // === 飲み物 ===
      // コカ・コーラ 500ml
      '4902102072352': {
        'name': 'コカ・コーラ',
        'quantity': 500.0,
        'unit': 'ml',
        'calories': 225.0,
        'protein': 0.0,
        'carbohydrates': 56.5,
        'fat': 0.0,
        'fiber': 0.0,
        'sugar': 56.5,
        'sodium': 0.0,
      },
      // ポカリスエット 500ml
      '4987035081111': {
        'name': 'ポカリスエット',
        'quantity': 500.0,
        'unit': 'ml',
        'calories': 125.0,
        'protein': 0.0,
        'carbohydrates': 31.0,
        'fat': 0.0,
        'fiber': 0.0,
        'sugar': 31.0,
        'sodium': 245.0,
      },
      // 午後の紅茶 ストレートティー 500ml
      '4902102116367': {
        'name': '午後の紅茶 ストレートティー',
        'quantity': 500.0,
        'unit': 'ml',
        'calories': 70.0,
        'protein': 0.0,
        'carbohydrates': 17.5,
        'fat': 0.0,
        'fiber': 0.0,
        'sugar': 17.5,
        'sodium': 0.0,
      },
      // いろはす 555ml
      '4902102116138': {
        'name': 'い・ろ・は・す',
        'quantity': 555.0,
        'unit': 'ml',
        'calories': 0.0,
        'protein': 0.0,
        'carbohydrates': 0.0,
        'fat': 0.0,
        'fiber': 0.0,
        'sugar': 0.0,
        'sodium': 0.0,
      },

      // === インスタント麺 ===
      // サッポロ一番 塩らーめん
      '4901734020103': {
        'name': 'サッポロ一番 塩らーめん',
        'quantity': 100.0,
        'unit': 'g',
        'calories': 443.0,
        'protein': 8.9,
        'carbohydrates': 60.1,
        'fat': 18.1,
        'fiber': 2.8,
        'sugar': 3.2,
        'sodium': 2100.0,
      },
      // 日清カップヌードル
      '4902105001035': {
        'name': '日清カップヌードル',
        'quantity': 77.0,
        'unit': 'g',
        'calories': 353.0,
        'protein': 10.5,
        'carbohydrates': 44.9,
        'fat': 14.6,
        'fiber': 3.1,
        'sugar': 4.8,
        'sodium': 1900.0,
      },
      // 日清焼そばU.F.O.
      '4902105001073': {
        'name': '日清焼そばU.F.O.',
        'quantity': 128.0,
        'unit': 'g',
        'calories': 556.0,
        'protein': 11.0,
        'carbohydrates': 66.6,
        'fat': 26.2,
        'fiber': 3.8,
        'sugar': 8.2,
        'sodium': 2300.0,
      },

      // === お菓子 ===
      // キットカット ミニ
      '4902201409414': {
        'name': 'キットカット ミニ',
        'quantity': 11.6,
        'unit': 'g',
        'calories': 64.0,
        'protein': 0.9,
        'carbohydrates': 7.0,
        'fat': 3.6,
        'fiber': 0.3,
        'sugar': 6.7,
        'sodium': 8.0,
      },
      // ポッキー チョコレート
      '4901005103030': {
        'name': 'ポッキー チョコレート',
        'quantity': 47.0,
        'unit': 'g',
        'calories': 233.0,
        'protein': 3.5,
        'carbohydrates': 31.4,
        'fat': 10.1,
        'fiber': 1.6,
        'sugar': 15.8,
        'sodium': 150.0,
      },
      // カルビー ポテトチップス うすしお味
      '4901330538477': {
        'name': 'ポテトチップス うすしお味',
        'quantity': 60.0,
        'unit': 'g',
        'calories': 336.0,
        'protein': 3.0,
        'carbohydrates': 32.4,
        'fat': 21.6,
        'fiber': 2.4,
        'sugar': 0.6,
        'sodium': 600.0,
      },

      // === 調味料 ===
      // キューピー マヨネーズ
      '4901577018916': {
        'name': 'キューピー マヨネーズ',
        'quantity': 500.0,
        'unit': 'g',
        'calories': 3570.0, // 100gあたり714kcal
        'protein': 12.0,
        'carbohydrates': 15.0,
        'fat': 385.0,
        'fiber': 0.0,
        'sugar': 15.0,
        'sodium': 2500.0,
      },

      // === 乳製品 ===
      // 明治おいしい牛乳 1000ml
      '4902705001114': {
        'name': '明治おいしい牛乳',
        'quantity': 1000.0,
        'unit': 'ml',
        'calories': 670.0,
        'protein': 34.0,
        'carbohydrates': 48.0,
        'fat': 38.0,
        'fiber': 0.0,
        'sugar': 48.0,
        'sodium': 1000.0,
      },
      // ダノンヨーグルト
      '3760008370001': {
        'name': 'ダノンヨーグルト',
        'quantity': 75.0,
        'unit': 'g',
        'calories': 47.0,
        'protein': 2.8,
        'carbohydrates': 6.8,
        'fat': 0.8,
        'fiber': 0.0,
        'sugar': 6.8,
        'sodium': 38.0,
      },

      // === パン ===
      // ヤマザキ 食パン
      '4903110012345': {
        'name': 'ヤマザキ 食パン',
        'quantity': 340.0,
        'unit': 'g',
        'calories': 924.0,
        'protein': 25.9,
        'carbohydrates': 170.0,
        'fat': 13.6,
        'fiber': 8.8,
        'sugar': 13.6,
        'sodium': 1360.0,
      },
    };
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
      name: '商品名不明 (バーコード: ${barcode.length > 10 ? barcode.substring(0, 10) + '...' : barcode})',
      quantity: 100.0,
      unit: 'g',
      calories: 100.0, // デフォルトで少しカロリーを設定
      nutritionInfo: const NutritionInfo(
        protein: 5.0,    // 一般的な食品の平均値
        carbohydrates: 15.0,
        fat: 3.0,
        fiber: 1.0,
        sugar: 5.0,
        sodium: 100.0,
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