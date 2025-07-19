
class FoodTranslationService {
  static final FoodTranslationService _instance = FoodTranslationService._internal();
  factory FoodTranslationService() => _instance;
  FoodTranslationService._internal();

  // 英語から日本語への食品名翻訳辞書
  static final Map<String, String> _translationMap = {
    // 主食
    'rice': 'ご飯',
    'white rice': '白米',
    'brown rice': '玄米',
    'bread': 'パン',
    'toast': 'トースト',
    'pasta': 'パスタ',
    'noodles': '麺類',
    'ramen': 'ラーメン',
    'udon': 'うどん',
    'soba': 'そば',
    'spaghetti': 'スパゲッティ',
    
    // 野菜
    'vegetables': '野菜',
    'salad': 'サラダ',
    'lettuce': 'レタス',
    'tomato': 'トマト',
    'cucumber': 'キュウリ',
    'carrot': 'ニンジン',
    'onion': '玉ねぎ',
    'potato': 'ジャガイモ',
    'sweet potato': 'サツマイモ',
    'broccoli': 'ブロッコリー',
    'cabbage': 'キャベツ',
    'spinach': 'ほうれん草',
    'corn': 'とうもろこし',
    'green pepper': 'ピーマン',
    'bell pepper': 'パプリカ',
    'mushroom': 'きのこ',
    'eggplant': 'なす',
    'radish': '大根',
    
    // 肉類
    'meat': '肉',
    'chicken': '鶏肉',
    'beef': '牛肉',
    'pork': '豚肉',
    'chicken breast': '鶏胸肉',
    'chicken thigh': '鶏もも肉',
    'ground beef': '牛ひき肉',
    'ground pork': '豚ひき肉',
    'bacon': 'ベーコン',
    'ham': 'ハム',
    'sausage': 'ソーセージ',
    
    // 魚介類
    'fish': '魚',
    'salmon': 'サーモン',
    'tuna': 'マグロ',
    'mackerel': 'サバ',
    'sardine': 'イワシ',
    'shrimp': 'エビ',
    'crab': 'カニ',
    'squid': 'イカ',
    'octopus': 'タコ',
    
    // 卵・乳製品
    'egg': '卵',
    'eggs': '卵',
    'milk': '牛乳',
    'cheese': 'チーズ',
    'yogurt': 'ヨーグルト',
    'butter': 'バター',
    
    // 果物
    'fruit': '果物',
    'apple': 'りんご',
    'banana': 'バナナ',
    'orange': 'オレンジ',
    'grape': 'ぶどう',
    'strawberry': 'いちご',
    'peach': '桃',
    'pear': '梨',
    'melon': 'メロン',
    'watermelon': 'スイカ',
    'pineapple': 'パイナップル',
    'kiwi': 'キウイ',
    'mango': 'マンゴー',
    
    // 日本料理
    'sushi': '寿司',
    'sashimi': '刺身',
    'tempura': '天ぷら',
    'miso soup': '味噌汁',
    'yakitori': '焼き鳥',
    'teriyaki': '照り焼き',
    'katsu': 'カツ',
    'tonkatsu': 'とんかつ',
    'karaage': '唐揚げ',
    'gyoza': '餃子',
    'takoyaki': 'たこ焼き',
    'okonomiyaki': 'お好み焼き',
    'onigiri': 'おにぎり',
    'bento': '弁当',
    'donburi': '丼',
    'curry': 'カレー',
    'katsudon': 'カツ丼',
    'oyakodon': '親子丼',
    'gyudon': '牛丼',
    
    // スナック・お菓子
    'snack': 'スナック',
    'cookie': 'クッキー',
    'cake': 'ケーキ',
    'chocolate': 'チョコレート',
    'candy': 'キャンディ',
    'ice cream': 'アイスクリーム',
    'chips': 'チップス',
    'crackers': 'クラッカー',
    'nuts': 'ナッツ',
    
    // 飲み物
    'water': '水',
    'tea': 'お茶',
    'coffee': 'コーヒー',
    'juice': 'ジュース',
    'soda': '炭酸飲料',
    'beer': 'ビール',
    'wine': 'ワイン',
    'sake': '日本酒',
    
    // 調理方法
    'fried': '揚げ',
    'grilled': '焼き',
    'boiled': '茹で',
    'steamed': '蒸し',
    'roasted': 'ロースト',
    'baked': '焼き',
    'raw': '生',
    
    // その他
    'soup': 'スープ',
    'sandwich': 'サンドイッチ',
    'pizza': 'ピザ',
    'hamburger': 'ハンバーガー',
    'french fries': 'フライドポテト',
    'salad': 'サラダ',
    'dessert': 'デザート',
    'meal': '食事',
    'dish': '料理',
  };

  // 部分一致用のキーワードマップ
  static final Map<String, String> _keywordMap = {
    'chicken': '鶏',
    'beef': '牛',
    'pork': '豚',
    'fish': '魚',
    'rice': 'ご飯',
    'bread': 'パン',
    'vegetable': '野菜',
    'fruit': '果物',
    'soup': 'スープ',
    'salad': 'サラダ',
    'fried': '揚げ',
    'grilled': '焼き',
    'boiled': '茹で',
    'steamed': '蒸し',
  };

  /// 英語の食品名を日本語に翻訳
  String translateFoodName(String englishName) {
    if (englishName.isEmpty) return englishName;
    
    final lowercaseName = englishName.toLowerCase().trim();
    
    // 完全一致での翻訳を試行
    if (_translationMap.containsKey(lowercaseName)) {
      return _translationMap[lowercaseName]!;
    }
    
    // 部分一致での翻訳を試行
    String translatedName = englishName;
    
    for (final entry in _keywordMap.entries) {
      if (lowercaseName.contains(entry.key)) {
        translatedName = translatedName.replaceAllMapped(
          RegExp(entry.key, caseSensitive: false),
          (match) => entry.value,
        );
      }
    }
    
    // より詳細な翻訳ルール
    translatedName = _applyAdvancedTranslation(translatedName, lowercaseName);
    
    return translatedName;
  }

  /// より詳細な翻訳ルールを適用
  String _applyAdvancedTranslation(String name, String lowercaseName) {
    // "with" を "〜入り" に変換
    if (lowercaseName.contains('with ')) {
      name = name.replaceAllMapped(
        RegExp(r'\bwith\s+(\w+)', caseSensitive: false),
        (match) {
          final ingredient = match.group(1)!;
          final translatedIngredient = translateFoodName(ingredient);
          return '${translatedIngredient}入り';
        },
      );
    }
    
    // "and" を "と" に変換
    name = name.replaceAllMapped(
      RegExp(r'\s+and\s+', caseSensitive: false),
      (match) => 'と',
    );
    
    // 一般的な調理法の翻訳
    final cookingMethods = {
      'deep fried': '揚げ',
      'pan fried': '焼き',
      'stir fried': '炒め',
      'deep-fried': '揚げ',
      'pan-fried': '焼き',
      'stir-fried': '炒め',
    };
    
    for (final entry in cookingMethods.entries) {
      if (lowercaseName.contains(entry.key)) {
        name = name.replaceAllMapped(
          RegExp(entry.key, caseSensitive: false),
          (match) => entry.value,
        );
      }
    }
    
    return name;
  }

  /// 複数の食品名をまとめて翻訳
  List<String> translateFoodNames(List<String> englishNames) {
    return englishNames.map((name) => translateFoodName(name)).toList();
  }

  /// カスタム翻訳を追加
  void addCustomTranslation(String english, String japanese) {
    _translationMap[english.toLowerCase()] = japanese;
  }

  /// 翻訳辞書に新しいエントリを追加
  void addTranslations(Map<String, String> translations) {
    for (final entry in translations.entries) {
      _translationMap[entry.key.toLowerCase()] = entry.value;
    }
  }

  /// 利用可能な翻訳数を取得
  int get translationCount => _translationMap.length;

  /// 翻訳辞書をクリア（テスト用）
  void clearCustomTranslations() {
    // カスタム翻訳のみクリアし、デフォルト翻訳は保持
  }
}