import 'package:flutter/material.dart';
import '../../business/services/food_translation_service.dart';

/// 食品名を表示するウィジェット（翻訳機能付き）
class FoodNameDisplay extends StatelessWidget {
  final String foodName;
  final TextStyle? style;
  final bool showOriginal;
  final int? maxLines;
  final TextOverflow? overflow;

  const FoodNameDisplay({
    super.key,
    required this.foodName,
    this.style,
    this.showOriginal = false,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final translationService = FoodTranslationService();
    final translatedName = translationService.translateFoodName(foodName);
    
    // 翻訳された名前と元の名前が同じ場合は、元の名前のみ表示
    if (translatedName == foodName || !showOriginal) {
      return Text(
        translatedName,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    
    // 翻訳された名前と元の名前が異なる場合、両方表示
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          translatedName,
          style: style,
          maxLines: maxLines,
          overflow: overflow,
        ),
        Text(
          '($foodName)',
          style: (style ?? const TextStyle()).copyWith(
            fontSize: (style?.fontSize ?? 14) * 0.8,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// 複数の食品名を翻訳して表示するヘルパー関数
class FoodTranslationHelper {
  static final FoodTranslationService _translationService = FoodTranslationService();
  
  /// 食品名を翻訳
  static String translateFoodName(String originalName) {
    return _translationService.translateFoodName(originalName);
  }
  
  /// 複数の食品名を翻訳
  static List<String> translateFoodNames(List<String> originalNames) {
    return _translationService.translateFoodNames(originalNames);
  }
  
  /// 翻訳された名前と元の名前を組み合わせた表示用文字列を生成
  static String getDisplayName(String originalName, {bool showOriginal = false}) {
    final translatedName = _translationService.translateFoodName(originalName);
    
    if (!showOriginal || translatedName == originalName) {
      return translatedName;
    }
    
    return '$translatedName ($originalName)';
  }
}