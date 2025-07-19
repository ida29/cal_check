import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SetupService {
  static final SetupService _instance = SetupService._internal();
  factory SetupService() => _instance;
  SetupService._internal();

  static const String _isSetupCompleteKey = 'is_setup_complete';
  static const String _userProfileKey = 'user_profile';
  static const String _apiKeyKey = 'openrouter_api_key';

  /// Check if initial setup is complete
  Future<bool> isSetupComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSetupCompleteKey) ?? false;
  }

  /// Mark setup as complete
  Future<void> markSetupComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isSetupCompleteKey, true);
  }

  /// Save user profile information
  Future<void> saveUserProfile({
    required int age,
    required String gender,
    required double height,
    required double weight,
    double? targetWeight,
    required String activityLevel,
    required String goal,
    String? timeframe,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final profile = UserProfile(
      age: age,
      gender: gender,
      height: height,
      weight: weight,
      targetWeight: targetWeight,
      activityLevel: activityLevel,
      goal: goal,
      timeframe: timeframe,
      createdAt: DateTime.now(),
    );
    
    await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
  }

  /// Get user profile
  Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);
    
    if (profileJson == null) return null;
    
    try {
      final profileMap = json.decode(profileJson) as Map<String, dynamic>;
      return UserProfile.fromJson(profileMap);
    } catch (e) {
      print('Error parsing user profile: $e');
      return null;
    }
  }

  /// Save API key
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
  }

  /// Get API key
  Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  /// Calculate BMR (Basal Metabolic Rate) using Harris-Benedict equation
  Future<double?> calculateBMR() async {
    final profile = await getUserProfile();
    if (profile == null) return null;

    double bmr;
    if (profile.gender.toLowerCase() == 'male') {
      bmr = 88.362 + (13.397 * profile.weight) + (4.799 * profile.height) - (5.677 * profile.age);
    } else {
      bmr = 447.593 + (9.247 * profile.weight) + (3.098 * profile.height) - (4.330 * profile.age);
    }

    return bmr;
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  Future<double?> calculateTDEE() async {
    final bmr = await calculateBMR();
    final profile = await getUserProfile();
    
    if (bmr == null || profile == null) return null;

    double activityMultiplier;
    switch (profile.activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'light':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
        activityMultiplier = 1.55;
        break;
      case 'very':
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.2;
    }

    return bmr * activityMultiplier;
  }

  /// Calculate daily calorie goal based on user's goal
  Future<double?> calculateDailyCalorieGoal() async {
    final tdee = await calculateTDEE();
    final profile = await getUserProfile();
    
    if (tdee == null || profile == null) return null;

    switch (profile.goal) {
      case 'lose_weight':
        return tdee - 500; // 500 calorie deficit for 1 lb/week loss
      case 'gain_weight':
        return tdee + 500; // 500 calorie surplus for 1 lb/week gain
      case 'maintain_weight':
      default:
        return tdee;
    }
  }

  /// Calculate BMI
  Future<double?> calculateBMI() async {
    final profile = await getUserProfile();
    if (profile == null) return null;

    final heightInMeters = profile.height / 100;
    return profile.weight / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  Future<String?> getBMICategory() async {
    final bmi = await calculateBMI();
    if (bmi == null) return null;

    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  /// Reset all setup data
  Future<void> resetSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isSetupCompleteKey);
    await prefs.remove(_userProfileKey);
    await prefs.remove(_apiKeyKey);
  }

  /// Update user profile
  Future<void> updateUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
  }
}

class UserProfile {
  final int age;
  final String gender;
  final double height; // in cm
  final double weight; // in kg
  final double? targetWeight; // in kg
  final String activityLevel;
  final String goal;
  final String? timeframe;
  final DateTime createdAt;

  UserProfile({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.targetWeight,
    required this.activityLevel,
    required this.goal,
    this.timeframe,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'goal': goal,
      'timeframe': timeframe,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      height: (json['height'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      targetWeight: json['targetWeight'] != null ? (json['targetWeight']).toDouble() : null,
      activityLevel: json['activityLevel'] ?? '',
      goal: json['goal'] ?? '',
      timeframe: json['timeframe'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserProfile copyWith({
    int? age,
    String? gender,
    double? height,
    double? weight,
    double? targetWeight,
    String? activityLevel,
    String? goal,
    String? timeframe,
    DateTime? createdAt,
  }) {
    return UserProfile(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      timeframe: timeframe ?? this.timeframe,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}