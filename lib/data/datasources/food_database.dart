class FoodDatabase {
  static final List<Map<String, dynamic>> foods = [
    // ご飯・パン類
    {'name': '白米（茶碗1杯）', 'category': 'rice', 'calories': 235, 'protein': 3.8, 'carbs': 55.7, 'fat': 0.4, 'unit': '150g'},
    {'name': '玄米（茶碗1杯）', 'category': 'rice', 'calories': 247, 'protein': 4.2, 'carbs': 53.4, 'fat': 1.5, 'unit': '150g'},
    {'name': 'おにぎり（梅）', 'category': 'rice', 'calories': 168, 'protein': 2.8, 'carbs': 38.0, 'fat': 0.3, 'unit': '100g'},
    {'name': 'おにぎり（鮭）', 'category': 'rice', 'calories': 187, 'protein': 5.1, 'carbs': 36.5, 'fat': 1.4, 'unit': '100g'},
    {'name': '食パン（6枚切り1枚）', 'category': 'bread', 'calories': 158, 'protein': 5.6, 'carbs': 28.0, 'fat': 2.5, 'unit': '60g'},
    {'name': 'クロワッサン', 'category': 'bread', 'calories': 179, 'protein': 3.0, 'carbs': 20.8, 'fat': 9.0, 'unit': '40g'},
    {'name': 'うどん（1玉）', 'category': 'noodles', 'calories': 231, 'protein': 5.9, 'carbs': 48.5, 'fat': 0.6, 'unit': '220g'},
    {'name': 'そば（1玉）', 'category': 'noodles', 'calories': 260, 'protein': 9.6, 'carbs': 52.0, 'fat': 1.8, 'unit': '200g'},
    {'name': 'ラーメン（醤油）', 'category': 'noodles', 'calories': 470, 'protein': 21.0, 'carbs': 61.0, 'fat': 15.0, 'unit': '1杯'},
    {'name': 'パスタ（ミートソース）', 'category': 'noodles', 'calories': 614, 'protein': 20.1, 'carbs': 77.7, 'fat': 21.4, 'unit': '1皿'},
    
    // 肉類
    {'name': '牛肉（もも肉）', 'category': 'meat', 'calories': 246, 'protein': 18.9, 'carbs': 0.3, 'fat': 18.7, 'unit': '100g'},
    {'name': '牛肉（バラ肉）', 'category': 'meat', 'calories': 517, 'protein': 11.0, 'carbs': 0.1, 'fat': 50.0, 'unit': '100g'},
    {'name': '豚肉（ロース）', 'category': 'meat', 'calories': 263, 'protein': 19.3, 'carbs': 0.2, 'fat': 19.2, 'unit': '100g'},
    {'name': '豚肉（バラ肉）', 'category': 'meat', 'calories': 434, 'protein': 14.4, 'carbs': 0.1, 'fat': 40.1, 'unit': '100g'},
    {'name': '鶏肉（もも肉・皮なし）', 'category': 'meat', 'calories': 127, 'protein': 19.0, 'carbs': 0.0, 'fat': 5.2, 'unit': '100g'},
    {'name': '鶏肉（むね肉・皮なし）', 'category': 'meat', 'calories': 116, 'protein': 23.3, 'carbs': 0.1, 'fat': 1.9, 'unit': '100g'},
    {'name': 'ハム', 'category': 'meat', 'calories': 196, 'protein': 16.5, 'carbs': 1.3, 'fat': 13.8, 'unit': '100g'},
    {'name': 'ソーセージ', 'category': 'meat', 'calories': 321, 'protein': 13.2, 'carbs': 3.0, 'fat': 28.5, 'unit': '100g'},
    
    // 魚介類
    {'name': 'さけ（焼き）', 'category': 'fish', 'calories': 177, 'protein': 29.1, 'carbs': 0.1, 'fat': 6.0, 'unit': '100g'},
    {'name': 'まぐろ（赤身）', 'category': 'fish', 'calories': 125, 'protein': 26.4, 'carbs': 0.1, 'fat': 1.4, 'unit': '100g'},
    {'name': 'さば（焼き）', 'category': 'fish', 'calories': 318, 'protein': 25.2, 'carbs': 0.3, 'fat': 23.8, 'unit': '100g'},
    {'name': 'あじ（焼き）', 'category': 'fish', 'calories': 170, 'protein': 27.5, 'carbs': 0.1, 'fat': 6.4, 'unit': '100g'},
    {'name': 'えび（茹で）', 'category': 'fish', 'calories': 83, 'protein': 18.4, 'carbs': 0.1, 'fat': 0.6, 'unit': '100g'},
    {'name': 'いか（生）', 'category': 'fish', 'calories': 83, 'protein': 17.9, 'carbs': 0.1, 'fat': 0.8, 'unit': '100g'},
    {'name': 'たこ（茹で）', 'category': 'fish', 'calories': 99, 'protein': 21.7, 'carbs': 0.1, 'fat': 0.7, 'unit': '100g'},
    
    // 卵・乳製品
    {'name': '卵（1個）', 'category': 'egg', 'calories': 76, 'protein': 6.2, 'carbs': 0.2, 'fat': 5.2, 'unit': '50g'},
    {'name': '牛乳（1杯）', 'category': 'dairy', 'calories': 134, 'protein': 6.6, 'carbs': 9.6, 'fat': 7.6, 'unit': '200ml'},
    {'name': 'ヨーグルト（無糖）', 'category': 'dairy', 'calories': 62, 'protein': 3.6, 'carbs': 4.9, 'fat': 3.0, 'unit': '100g'},
    {'name': 'チーズ（プロセス）', 'category': 'dairy', 'calories': 339, 'protein': 22.7, 'carbs': 1.3, 'fat': 26.0, 'unit': '100g'},
    {'name': 'バター', 'category': 'dairy', 'calories': 75, 'protein': 0.1, 'carbs': 0.0, 'fat': 8.3, 'unit': '10g'},
    
    // 野菜類
    {'name': 'キャベツ（生）', 'category': 'vegetable', 'calories': 23, 'protein': 1.3, 'carbs': 5.2, 'fat': 0.2, 'unit': '100g'},
    {'name': 'レタス（生）', 'category': 'vegetable', 'calories': 12, 'protein': 0.6, 'carbs': 2.8, 'fat': 0.1, 'unit': '100g'},
    {'name': 'トマト（中1個）', 'category': 'vegetable', 'calories': 30, 'protein': 1.2, 'carbs': 6.3, 'fat': 0.2, 'unit': '150g'},
    {'name': 'きゅうり（中1本）', 'category': 'vegetable', 'calories': 14, 'protein': 1.0, 'carbs': 3.0, 'fat': 0.1, 'unit': '100g'},
    {'name': 'にんじん（中1本）', 'category': 'vegetable', 'calories': 54, 'protein': 1.1, 'carbs': 12.8, 'fat': 0.2, 'unit': '150g'},
    {'name': 'じゃがいも（中1個）', 'category': 'vegetable', 'calories': 103, 'protein': 2.4, 'carbs': 23.7, 'fat': 0.1, 'unit': '150g'},
    {'name': 'たまねぎ（中1個）', 'category': 'vegetable', 'calories': 66, 'protein': 1.8, 'carbs': 15.8, 'fat': 0.2, 'unit': '180g'},
    {'name': 'ほうれん草（茹で）', 'category': 'vegetable', 'calories': 25, 'protein': 2.6, 'carbs': 4.0, 'fat': 0.5, 'unit': '100g'},
    {'name': 'ブロッコリー（茹で）', 'category': 'vegetable', 'calories': 30, 'protein': 3.9, 'carbs': 5.2, 'fat': 0.4, 'unit': '100g'},
    
    // 果物類
    {'name': 'りんご（中1個）', 'category': 'fruit', 'calories': 138, 'protein': 0.5, 'carbs': 37.2, 'fat': 0.3, 'unit': '250g'},
    {'name': 'バナナ（1本）', 'category': 'fruit', 'calories': 77, 'protein': 1.0, 'carbs': 20.3, 'fat': 0.2, 'unit': '90g'},
    {'name': 'みかん（中1個）', 'category': 'fruit', 'calories': 34, 'protein': 0.5, 'carbs': 8.8, 'fat': 0.1, 'unit': '80g'},
    {'name': 'いちご（5粒）', 'category': 'fruit', 'calories': 25, 'protein': 0.7, 'carbs': 6.4, 'fat': 0.1, 'unit': '75g'},
    {'name': 'ぶどう（10粒）', 'category': 'fruit', 'calories': 69, 'protein': 0.6, 'carbs': 18.1, 'fat': 0.2, 'unit': '100g'},
    {'name': 'もも（中1個）', 'category': 'fruit', 'calories': 85, 'protein': 1.3, 'carbs': 22.2, 'fat': 0.2, 'unit': '200g'},
    {'name': 'オレンジ（中1個）', 'category': 'fruit', 'calories': 69, 'protein': 1.4, 'carbs': 17.4, 'fat': 0.2, 'unit': '150g'},
    
    // 豆類・豆製品
    {'name': '納豆（1パック）', 'category': 'beans', 'calories': 100, 'protein': 8.3, 'carbs': 6.1, 'fat': 5.0, 'unit': '50g'},
    {'name': '豆腐（木綿・1/4丁）', 'category': 'beans', 'calories': 54, 'protein': 5.3, 'carbs': 1.2, 'fat': 3.2, 'unit': '75g'},
    {'name': '豆腐（絹ごし・1/4丁）', 'category': 'beans', 'calories': 42, 'protein': 3.7, 'carbs': 1.5, 'fat': 2.3, 'unit': '75g'},
    {'name': '油揚げ（1枚）', 'category': 'beans', 'calories': 116, 'protein': 5.5, 'carbs': 0.4, 'fat': 10.1, 'unit': '30g'},
    {'name': '味噌汁（1杯）', 'category': 'beans', 'calories': 40, 'protein': 2.2, 'carbs': 5.7, 'fat': 1.2, 'unit': '200ml'},
    
    // 飲み物
    {'name': 'コーヒー（ブラック）', 'category': 'drink', 'calories': 8, 'protein': 0.4, 'carbs': 1.4, 'fat': 0.0, 'unit': '200ml'},
    {'name': '紅茶（無糖）', 'category': 'drink', 'calories': 2, 'protein': 0.2, 'carbs': 0.2, 'fat': 0.0, 'unit': '200ml'},
    {'name': '緑茶', 'category': 'drink', 'calories': 0, 'protein': 0.0, 'carbs': 0.0, 'fat': 0.0, 'unit': '200ml'},
    {'name': 'オレンジジュース', 'category': 'drink', 'calories': 84, 'protein': 1.2, 'carbs': 20.6, 'fat': 0.2, 'unit': '200ml'},
    {'name': 'コーラ', 'category': 'drink', 'calories': 92, 'protein': 0.0, 'carbs': 23.2, 'fat': 0.0, 'unit': '200ml'},
    {'name': 'ビール', 'category': 'drink', 'calories': 126, 'protein': 0.9, 'carbs': 10.8, 'fat': 0.0, 'unit': '350ml'},
    
    // お菓子・デザート
    {'name': 'ショートケーキ', 'category': 'sweets', 'calories': 366, 'protein': 4.6, 'carbs': 43.0, 'fat': 19.9, 'unit': '100g'},
    {'name': 'チョコレート', 'category': 'sweets', 'calories': 279, 'protein': 2.8, 'carbs': 27.9, 'fat': 17.5, 'unit': '50g'},
    {'name': 'ポテトチップス', 'category': 'sweets', 'calories': 332, 'protein': 2.8, 'carbs': 32.8, 'fat': 21.1, 'unit': '60g'},
    {'name': 'アイスクリーム', 'category': 'sweets', 'calories': 180, 'protein': 3.9, 'carbs': 23.2, 'fat': 8.0, 'unit': '100g'},
    {'name': 'どら焼き', 'category': 'sweets', 'calories': 271, 'protein': 5.9, 'carbs': 55.6, 'fat': 3.5, 'unit': '100g'},
    {'name': '大福', 'category': 'sweets', 'calories': 165, 'protein': 3.5, 'carbs': 37.0, 'fat': 0.5, 'unit': '70g'},
    
    // ファーストフード
    {'name': 'ハンバーガー', 'category': 'fastfood', 'calories': 275, 'protein': 13.3, 'carbs': 30.3, 'fat': 10.4, 'unit': '1個'},
    {'name': 'チーズバーガー', 'category': 'fastfood', 'calories': 323, 'protein': 16.2, 'carbs': 30.8, 'fat': 14.0, 'unit': '1個'},
    {'name': 'ホットドッグ', 'category': 'fastfood', 'calories': 290, 'protein': 10.4, 'carbs': 24.3, 'fat': 17.3, 'unit': '1本'},
    {'name': 'フライドポテト（M）', 'category': 'fastfood', 'calories': 320, 'protein': 3.9, 'carbs': 41.0, 'fat': 15.5, 'unit': '1個'},
    {'name': 'ピザ（マルゲリータ）', 'category': 'fastfood', 'calories': 272, 'protein': 11.0, 'carbs': 33.6, 'fat': 10.1, 'unit': '1切れ'},
    {'name': 'フライドチキン', 'category': 'fastfood', 'calories': 237, 'protein': 18.4, 'carbs': 7.9, 'fat': 14.6, 'unit': '1ピース'},
    
    // 定食・料理
    {'name': 'カレーライス', 'category': 'meal', 'calories': 862, 'protein': 21.0, 'carbs': 124.5, 'fat': 26.5, 'unit': '1皿'},
    {'name': '親子丼', 'category': 'meal', 'calories': 684, 'protein': 31.1, 'carbs': 97.5, 'fat': 16.0, 'unit': '1杯'},
    {'name': '牛丼', 'category': 'meal', 'calories': 771, 'protein': 23.7, 'carbs': 104.1, 'fat': 25.7, 'unit': '1杯'},
    {'name': 'かつ丼', 'category': 'meal', 'calories': 893, 'protein': 32.7, 'carbs': 105.8, 'fat': 31.9, 'unit': '1杯'},
    {'name': '天丼', 'category': 'meal', 'calories': 805, 'protein': 24.8, 'carbs': 113.2, 'fat': 23.4, 'unit': '1杯'},
    {'name': '寿司（にぎり10貫）', 'category': 'meal', 'calories': 420, 'protein': 33.0, 'carbs': 64.0, 'fat': 3.0, 'unit': '10貫'},
    {'name': 'お弁当（幕の内）', 'category': 'meal', 'calories': 695, 'protein': 23.2, 'carbs': 96.4, 'fat': 21.8, 'unit': '1個'},
  ];

  static List<Map<String, dynamic>> searchFood(String query) {
    if (query.isEmpty) return [];
    
    final lowerQuery = query.toLowerCase();
    return foods.where((food) {
      final name = food['name'].toString().toLowerCase();
      return name.contains(lowerQuery);
    }).toList();
  }

  static List<String> getCategories() {
    final categories = foods.map((food) => food['category'] as String).toSet().toList();
    categories.sort();
    return categories;
  }

  static List<Map<String, dynamic>> getFoodsByCategory(String category) {
    return foods.where((food) => food['category'] == category).toList();
  }

  // Placeholder method for meal records - returns empty list since this is a static food database
  static Future<List<Map<String, dynamic>>> getMealsByDateRange(DateTime start, DateTime end) async {
    return [];
  }
}