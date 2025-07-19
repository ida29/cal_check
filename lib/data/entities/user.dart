import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum Gender { male, female, other }

enum ActivityLevel { sedentary, lightlyActive, moderatelyActive, veryActive, extraActive }

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required int age,
    required Gender gender,
    required double height, // in cm
    required double weight, // in kg
    required ActivityLevel activityLevel,
    required double targetCalories,
    @Default(true) bool isFirstTimeUser,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}