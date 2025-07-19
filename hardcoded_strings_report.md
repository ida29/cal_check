# Hardcoded Strings to Localize Report

This report lists all hardcoded strings found in Dart files that should be localized. These are UI strings that are displayed to users but are not using AppLocalizations.

## lib/presentation/screens/home_screen.dart

1. **Line 181**: `'クイックアクション'` - Quick action label
2. **Line 195**: `'運動を記録'` - Exercise recording label  
3. **Line 196**: `'運動した内容を記録'` - Exercise recording subtitle
4. **Line 207**: `'食事履歴'` - Meal history label
5. **Line 208**: `'今日の食事を確認'` - Today's meal check subtitle
6. **Line 228**: `'水分記録'` - Water intake recording label
7. **Line 229**: `'水分摂取を記録'` - Water intake recording subtitle
8. **Line 233**: `'水分記録機能は準備中です'` - Water recording feature coming soon message
9. **Line 242**: `'統計'` - Statistics label
10. **Line 243**: `'進捗を確認'` - Progress check subtitle

## lib/presentation/screens/camera_screen.dart

1. **Line 117**: `'画像の選択に失敗しました'` - Image selection failed message

## lib/presentation/screens/settings_screen.dart

1. **Line 245**: `'Personal Information'` - Dialog title
2. **Line 250**: `'Name'` - Name field label
3. **Line 253**: `'Age'` - Age field label
4. **Line 257**: `'Height (cm)'` - Height field label
5. **Line 261**: `'Weight (kg)'` - Weight field label
6. **Line 275**: `'Profile updated!'` - Profile update success message
7. **Line 289**: `'Daily Calorie Goal'` - Dialog title
8. **Line 292**: `'Calories per day'` - Calories input label
9. **Line 293**: `'cal'` - Calorie unit suffix
10. **Line 306**: `'Calorie goal updated!'` - Calorie goal update success message
11. **Line 320**: `'Activity Level'` - Dialog title
12. **Line 324-329**: Activity level options:
    - `'Sedentary'`
    - `'Lightly Active'`
    - `'Moderately Active'`
    - `'Very Active'`
    - `'Extra Active'`
13. **Line 345**: `'Activity level updated!'` - Activity level update success message
14. **Line 380**: `'English'` - English language option
15. **Line 381**: `'日本語'` - Japanese language option
16. **Line 425**: `'Units'` - Units dialog title
17. **Line 430**: `'Metric (kg, cm)'` - Metric units option
18. **Line 436**: `'Imperial (lbs, ft)'` - Imperial units option

## lib/presentation/screens/history_screen.dart

1. **Line 44**: `'日別'` - Daily view option
2. **Line 45**: `'週別'` - Weekly view option
3. **Line 46**: `'月別'` - Monthly view option
4. **Line 206**: `'No meals recorded'` - Empty state title
5. **Line 213**: `'Start taking photos of your meals!'` - Empty state subtitle
6. **Line 311**: `'items'` - Item count label
7. **Line 513**: `'Image not found'` - Image error message
8. **Line 562**: `'Nutrition Breakdown'` - Nutrition section title
9. **Line 594**: `'Fiber'` - Fiber nutrition label
10. **Line 603**: `'Sugar'` - Sugar nutrition label
11. **Line 657**: `'Delete'` - Delete button label
12. **Line 667**: `'Close'` - Close button label
13. **Line 732**: `'Delete Meal'` - Delete confirmation title
14. **Line 733**: `'Are you sure you want to delete this meal? This action cannot be undone.'` - Delete confirmation message
15. **Line 737**: `'Cancel'` - Cancel button label
16. **Line 751**: `'Meal deleted successfully'` - Meal deletion success message
17. **Line 758**: `'Failed to delete meal'` - Meal deletion failure message
18. **Line 765**: `'Delete'` - Delete confirmation button

## lib/presentation/screens/result_screen.dart

1. **Line 55**: `'エラーが発生しました: $e'` - Error occurred message (Japanese)
2. **Line 76**: `'バーコードが検出されませんでした。もう一度お試しください。'` - Barcode not detected message
3. **Line 87**: `'バーコードの読み取りに失敗しました。'` - Barcode reading failed message
4. **Line 102**: `'商品情報を取得できませんでした。'` - Product info retrieval failed message
5. **Line 156**: `'バーコードを解析中...'` - Analyzing barcode message
6. **Line 174**: `'Analysis Failed'` - Analysis failed title
7. **Line 182**: `'Retry'` - Retry button label
8. **Line 241**: `'Saving...'` - Saving state message
9. **Line 311**: `'items'` - Item count label (duplicate)
10. **Line 396**: `'Nutrition Summary'` - Nutrition summary title
11. **Line 505**: `'Failed to save meal. Please try again.'` - Save failure message
12. **Line 514**: `'Failed to save meal. Please try again.'` - Save failure message (duplicate)

## Recommendations

1. All these hardcoded strings should be added to the localization files (l10n/app_*.arb files)
2. Replace hardcoded strings with appropriate AppLocalizations calls
3. For error messages, consider creating a standardized error message format
4. Activity levels and other enumerated values should be localized
5. Consider grouping related strings (e.g., all nutrition-related strings) in the localization files for better organization
6. Ensure consistent formatting for similar messages across different screens