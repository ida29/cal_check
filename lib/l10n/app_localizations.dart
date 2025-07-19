import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Calorie Checker AI'**
  String get appTitle;

  /// Home screen title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// Camera screen title
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraTitle;

  /// History screen title
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// Statistics screen title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Button to take a picture
  ///
  /// In en, this message translates to:
  /// **'Take Picture'**
  String get takePicture;

  /// Button to select from gallery
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Text shown while analyzing image
  ///
  /// In en, this message translates to:
  /// **'Analyzing...'**
  String get analyzing;

  /// Calories label
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// Protein label
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// Carbohydrates label
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// Fat label
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// Today's total calories
  ///
  /// In en, this message translates to:
  /// **'Today\'s Total'**
  String get todayTotal;

  /// Weekly average calories
  ///
  /// In en, this message translates to:
  /// **'Weekly Average'**
  String get weeklyAverage;

  /// Message when no data is available
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// Language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Japanese language option
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirmation message for delete
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDelete;

  /// Food item label
  ///
  /// In en, this message translates to:
  /// **'Food Item'**
  String get foodItem;

  /// Meal time label
  ///
  /// In en, this message translates to:
  /// **'Meal Time'**
  String get mealTime;

  /// Breakfast meal
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// Lunch meal
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// Dinner meal
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// Snack meal
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// Recent meals section title
  ///
  /// In en, this message translates to:
  /// **'Recent Meals'**
  String get recentMeals;

  /// Daily goal progress text
  ///
  /// In en, this message translates to:
  /// **'% of daily goal'**
  String get dailyGoalProgress;

  /// Error message for camera failure
  ///
  /// In en, this message translates to:
  /// **'Failed to take picture'**
  String get failedTakePicture;

  /// Gallery feature placeholder
  ///
  /// In en, this message translates to:
  /// **'Gallery feature coming soon!'**
  String get galleryComingSoon;

  /// Camera screen title
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takePhoto;

  /// Tips dialog title
  ///
  /// In en, this message translates to:
  /// **'Tips for Best Results'**
  String get tipsForBestResults;

  /// Camera tip 1
  ///
  /// In en, this message translates to:
  /// **'• Ensure good lighting\n'**
  String get tip1;

  /// Camera tip 2
  ///
  /// In en, this message translates to:
  /// **'• Center the food in frame\n'**
  String get tip2;

  /// Camera tip 3
  ///
  /// In en, this message translates to:
  /// **'• Avoid shadows\n'**
  String get tip3;

  /// Camera tip 4
  ///
  /// In en, this message translates to:
  /// **'• Capture all items clearly\n'**
  String get tip4;

  /// Camera tip 5
  ///
  /// In en, this message translates to:
  /// **'• Keep camera steady'**
  String get tip5;

  /// Understanding confirmation button
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// User profile section
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// Personal info setting
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Profile update description
  ///
  /// In en, this message translates to:
  /// **'Update your profile details'**
  String get updateProfileDetails;

  /// Goals section title
  ///
  /// In en, this message translates to:
  /// **'Goals & Targets'**
  String get goalsTargets;

  /// Calorie goal setting
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Goal'**
  String get dailyCalorieGoal;

  /// Default calorie amount
  ///
  /// In en, this message translates to:
  /// **'2,000 calories'**
  String get caloriesAmount;

  /// Activity level setting
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// Activity level option
  ///
  /// In en, this message translates to:
  /// **'Moderately Active'**
  String get moderatelyActive;

  /// Notifications section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Meal reminder setting
  ///
  /// In en, this message translates to:
  /// **'Meal Reminders'**
  String get mealReminders;

  /// Meal reminder description
  ///
  /// In en, this message translates to:
  /// **'Get notified for meal times'**
  String get mealReminderDescription;

  /// Reminder times setting
  ///
  /// In en, this message translates to:
  /// **'Reminder Times'**
  String get reminderTimes;

  /// Default reminder schedule
  ///
  /// In en, this message translates to:
  /// **'Breakfast: 8:00 AM, Lunch: 12:00 PM, Dinner: 7:00 PM'**
  String get defaultReminderTimes;

  /// Reminder times placeholder
  ///
  /// In en, this message translates to:
  /// **'Reminder times feature coming soon!'**
  String get reminderTimesComingSoon;

  /// App preferences section
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// Dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Dark theme description
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// Units setting
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// Metric units option
  ///
  /// In en, this message translates to:
  /// **'Metric (kg, cm)'**
  String get metricUnits;

  /// Data management section
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// Export data feature
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// Export description
  ///
  /// In en, this message translates to:
  /// **'Export your meal history'**
  String get exportMealHistory;

  /// Export placeholder
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon!'**
  String get exportComingSoon;

  /// Clear data feature
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// Clear data description
  ///
  /// In en, this message translates to:
  /// **'Delete all meals and settings'**
  String get clearDataDescription;

  /// About section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// App version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Version number
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get versionNumber;

  /// Privacy policy link
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Privacy policy placeholder
  ///
  /// In en, this message translates to:
  /// **'Privacy policy feature coming soon!'**
  String get privacyPolicyComingSoon;

  /// Help and support link
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help support placeholder
  ///
  /// In en, this message translates to:
  /// **'Help & support feature coming soon!'**
  String get helpSupportComingSoon;

  /// Onboarding welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to Calorie Checker AI'**
  String get welcomeTitle;

  /// Onboarding welcome description
  ///
  /// In en, this message translates to:
  /// **'Track your meals and achieve your health goals with AI-powered food recognition'**
  String get welcomeDescription;

  /// Feature title
  ///
  /// In en, this message translates to:
  /// **'Photo Recognition'**
  String get photoRecognition;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Instantly identify food and calories from photos'**
  String get photoRecognitionDesc;

  /// Feature title
  ///
  /// In en, this message translates to:
  /// **'Smart Tracking'**
  String get smartTracking;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Automatically track nutrition and meal history'**
  String get smartTrackingDesc;

  /// Feature title
  ///
  /// In en, this message translates to:
  /// **'Progress Insights'**
  String get progressInsights;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Get detailed analytics and goal tracking'**
  String get progressInsightsDesc;

  /// Personal info screen title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformationTitle;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Age field
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// Age field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your age'**
  String get enterYourAge;

  /// Gender field
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Gender dropdown placeholder
  ///
  /// In en, this message translates to:
  /// **'Select your gender'**
  String get selectGender;

  /// Male option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Height field
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get height;

  /// Height field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your height'**
  String get enterYourHeight;

  /// Weight field
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight;

  /// Weight field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your weight'**
  String get enterYourWeight;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Daily calories
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// Total carbs
  ///
  /// In en, this message translates to:
  /// **'Total Carbs'**
  String get totalCarbs;

  /// Total protein
  ///
  /// In en, this message translates to:
  /// **'Total Protein'**
  String get totalProtein;

  /// Total fat
  ///
  /// In en, this message translates to:
  /// **'Total Fat'**
  String get totalFat;

  /// Goal label
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// Calorie intake
  ///
  /// In en, this message translates to:
  /// **'Calorie Intake'**
  String get calorieIntake;

  /// Calorie intake progress
  ///
  /// In en, this message translates to:
  /// **'Calorie Intake Progress'**
  String get calorieIntakeProgress;

  /// Macronutrient breakdown
  ///
  /// In en, this message translates to:
  /// **'Macronutrient Breakdown'**
  String get macronutrientBreakdown;

  /// Weekly goals progress
  ///
  /// In en, this message translates to:
  /// **'Weekly Goals Progress'**
  String get weeklyGoalsProgress;

  /// Calorie goal
  ///
  /// In en, this message translates to:
  /// **'Calorie Goal'**
  String get calorieGoal;

  /// Exercise goal
  ///
  /// In en, this message translates to:
  /// **'Exercise Goal'**
  String get exerciseGoal;

  /// Water intake
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get waterIntake;

  /// Meal history
  ///
  /// In en, this message translates to:
  /// **'Meal History'**
  String get mealHistory;

  /// Total calories
  ///
  /// In en, this message translates to:
  /// **'Total Calories'**
  String get totalCalories;

  /// Calorie amount
  ///
  /// In en, this message translates to:
  /// **'Calorie Amount'**
  String get calorieAmount;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// History tab
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// Statistics tab
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Analysis results screen title
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// Analyzing meal text
  ///
  /// In en, this message translates to:
  /// **'Analyzing your meal...'**
  String get analyzingMeal;

  /// Detected items section
  ///
  /// In en, this message translates to:
  /// **'Detected Items'**
  String get detectedItems;

  /// Add item button
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save to Meal History'**
  String get saveToMealHistory;

  /// Retake photo button
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get retakePhoto;

  /// Average label
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// Lowest label
  ///
  /// In en, this message translates to:
  /// **'Lowest'**
  String get lowest;

  /// Highest label
  ///
  /// In en, this message translates to:
  /// **'Highest'**
  String get highest;

  /// Nutrition breakdown section
  ///
  /// In en, this message translates to:
  /// **'Nutrition Breakdown'**
  String get nutritionBreakdown;

  /// Carbs percentage
  ///
  /// In en, this message translates to:
  /// **'Carbs %'**
  String get carbsPercentage;

  /// Fat percentage
  ///
  /// In en, this message translates to:
  /// **'Fat %'**
  String get fatPercentage;

  /// Protein percentage
  ///
  /// In en, this message translates to:
  /// **'Protein %'**
  String get proteinPercentage;

  /// Carbohydrates
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Edit feature placeholder
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon!'**
  String get editComingSoon;

  /// Add custom item placeholder
  ///
  /// In en, this message translates to:
  /// **'Add custom item feature coming soon!'**
  String get addCustomItemComingSoon;

  /// Meal saved message
  ///
  /// In en, this message translates to:
  /// **'Meal saved successfully!'**
  String get mealSavedSuccessfully;

  /// Personalize experience text
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience'**
  String get personalizeExperience;

  /// Week button
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Month button
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Year button
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Calorie intake trend
  ///
  /// In en, this message translates to:
  /// **'Calorie Intake Trend'**
  String get calorieIntakeTrend;

  /// Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get saturday;

  /// Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sunday;

  /// Food camera mode
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodMode;

  /// Barcode camera mode
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcodeMode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
