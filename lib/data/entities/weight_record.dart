import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_record.freezed.dart';
part 'weight_record.g.dart';

@freezed
class WeightRecord with _$WeightRecord {
  const factory WeightRecord({
    required String id,
    required DateTime recordedAt,
    required double weight, // in kg
    double? bodyFat, // percentage
    double? muscleMass, // in kg
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WeightRecord;

  factory WeightRecord.fromJson(Map<String, dynamic> json) =>
      _$WeightRecordFromJson(json);
}