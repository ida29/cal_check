// Script to add missing localizations to app_en.arb and app_ja.arb files
// Run with: dart add_missing_localizations.dart

import 'dart:io';
import 'dart:convert';

void main() {
  // Missing localizations to add
  final missingLocalizations = {
    // Home Screen
    'quickActions': {'en': 'Quick Actions', 'ja': 'クイックアクション'},
    'recordExercise': {'en': 'Record Exercise', 'ja': '運動を記録'},
    'recordExerciseSubtitle': {'en': 'Record your exercise', 'ja': '運動した内容を記録'},
    'mealHistoryAction': {'en': 'Meal History', 'ja': '食事履歴'},
    'checkTodaysMeals': {'en': 'Check today\'s meals', 'ja': '今日の食事を確認'},
    'recordWater': {'en': 'Water Intake', 'ja': '水分記録'},
    'recordWaterSubtitle': {'en': 'Record water intake', 'ja': '水分摂取を記録'},
    'waterRecordingComingSoon': {'en': 'Water recording feature is coming soon', 'ja': '水分記録機能は準備中です'},
    'statisticsAction': {'en': 'Statistics', 'ja': '統計'},
    'checkProgress': {'en': 'Check progress', 'ja': '進捗を確認'},
    
    // Camera Screen
    'imageSelectionFailed': {'en': 'Failed to select image', 'ja': '画像の選択に失敗しました'},
    
    // Settings Screen
    'personalInformationTitle': {'en': 'Personal Information', 'ja': '個人情報'},
    'name': {'en': 'Name', 'ja': '名前'},
    'age': {'en': 'Age', 'ja': '年齢'},
    'heightCm': {'en': 'Height (cm)', 'ja': '身長 (cm)'},
    'weightKg': {'en': 'Weight (kg)', 'ja': '体重 (kg)'},
    'profileUpdated': {'en': 'Profile updated!', 'ja': 'プロフィールを更新しました！'},
    'dailyCalorieGoalTitle': {'en': 'Daily Calorie Goal', 'ja': '1日のカロリー目標'},
    'caloriesPerDay': {'en': 'Calories per day', 'ja': '1日あたりのカロリー'},
    'calUnit': {'en': 'cal', 'ja': 'cal'},
    'calorieGoalUpdated': {'en': 'Calorie goal updated!', 'ja': 'カロリー目標を更新しました！'},
    'activityLevelTitle': {'en': 'Activity Level', 'ja': '活動レベル'},
    'sedentary': {'en': 'Sedentary', 'ja': '座り仕事中心'},
    'lightlyActive': {'en': 'Lightly Active', 'ja': 'やや活動的'},
    'veryActive': {'en': 'Very Active', 'ja': 'とても活動的'},
    'extraActive': {'en': 'Extra Active', 'ja': '非常に活動的'},
    'activityLevelUpdated': {'en': 'Activity level updated!', 'ja': '活動レベルを更新しました！'},
    'englishLanguage': {'en': 'English', 'ja': 'English'},
    'japaneseLanguage': {'en': '日本語', 'ja': '日本語'},
    'unitsTitle': {'en': 'Units', 'ja': '単位'},
    'metricUnitsOption': {'en': 'Metric (kg, cm)', 'ja': 'メートル法 (kg, cm)'},
    'imperialUnits': {'en': 'Imperial (lbs, ft)', 'ja': 'ヤード・ポンド法 (lbs, ft)'},
    
    // History Screen
    'dayView': {'en': 'Daily', 'ja': '日別'},
    'weekView': {'en': 'Weekly', 'ja': '週別'},
    'monthView': {'en': 'Monthly', 'ja': '月別'},
    'noMealsRecorded': {'en': 'No meals recorded', 'ja': '記録された食事はありません'},
    'startTakingPhotos': {'en': 'Start taking photos of your meals!', 'ja': '食事の写真を撮り始めましょう！'},
    'itemsCount': {'en': 'items', 'ja': '品目'},
    'imageNotFound': {'en': 'Image not found', 'ja': '画像が見つかりません'},
    'nutritionBreakdown': {'en': 'Nutrition Breakdown', 'ja': '栄養成分内訳'},
    'fiber': {'en': 'Fiber', 'ja': '食物繊維'},
    'sugar': {'en': 'Sugar', 'ja': '糖質'},
    'close': {'en': 'Close', 'ja': '閉じる'},
    'deleteMeal': {'en': 'Delete Meal', 'ja': '食事を削除'},
    'deleteMealConfirmation': {'en': 'Are you sure you want to delete this meal? This action cannot be undone.', 'ja': 'この食事を削除してもよろしいですか？この操作は取り消せません。'},
    'mealDeletedSuccessfully': {'en': 'Meal deleted successfully', 'ja': '食事を削除しました'},
    'failedToDeleteMeal': {'en': 'Failed to delete meal', 'ja': '食事の削除に失敗しました'},
    
    // Result Screen
    'errorOccurred': {'en': 'An error occurred', 'ja': 'エラーが発生しました'},
    'barcodeNotDetected': {'en': 'Barcode not detected. Please try again.', 'ja': 'バーコードが検出されませんでした。もう一度お試しください。'},
    'barcodeReadingFailed': {'en': 'Failed to read barcode.', 'ja': 'バーコードの読み取りに失敗しました。'},
    'productInfoRetrievalFailed': {'en': 'Could not retrieve product information.', 'ja': '商品情報を取得できませんでした。'},
    'analyzingBarcode': {'en': 'Analyzing barcode...', 'ja': 'バーコードを解析中...'},
    'analysisFailed': {'en': 'Analysis Failed', 'ja': '解析に失敗しました'},
    'retry': {'en': 'Retry', 'ja': '再試行'},
    'saving': {'en': 'Saving...', 'ja': '保存中...'},
    'nutritionSummary': {'en': 'Nutrition Summary', 'ja': '栄養成分サマリー'},
    'failedToSaveMeal': {'en': 'Failed to save meal. Please try again.', 'ja': '食事の保存に失敗しました。もう一度お試しください。'},
  };

  print('Adding missing localizations to arb files...\n');

  // Read existing files
  final enFile = File('lib/l10n/app_en.arb');
  final jaFile = File('lib/l10n/app_ja.arb');

  if (!enFile.existsSync() || !jaFile.existsSync()) {
    print('Error: Could not find localization files');
    return;
  }

  final enContent = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
  final jaContent = jsonDecode(jaFile.readAsStringSync()) as Map<String, dynamic>;

  int addedCount = 0;

  // Add missing localizations
  missingLocalizations.forEach((key, translations) {
    if (!enContent.containsKey(key)) {
      enContent[key] = translations['en'];
      jaContent[key] = translations['ja'];
      addedCount++;
      print('Added: $key');
    }
  });

  // Write back to files
  const encoder = JsonEncoder.withIndent('  ');
  enFile.writeAsStringSync(encoder.convert(enContent));
  jaFile.writeAsStringSync(encoder.convert(jaContent));

  print('\nSuccessfully added $addedCount new localizations!');
  print('\nNext steps:');
  print('1. Run: flutter gen-l10n');
  print('2. Update the Dart files to use these new localization keys');
}