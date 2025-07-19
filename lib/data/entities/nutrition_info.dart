import 'package:freezed_annotation/freezed_annotation.dart';

part 'nutrition_info.freezed.dart';
part 'nutrition_info.g.dart';

@freezed
class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    required double protein,
    required double carbohydrates,
    required double fat,
    @Default(0.0) double fiber,
    @Default(0.0) double sugar,
    @Default(0.0) double sodium,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}