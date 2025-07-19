// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recognition_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecognitionResultImpl _$$RecognitionResultImplFromJson(
        Map<String, dynamic> json) =>
    _$RecognitionResultImpl(
      imagePath: json['imagePath'] as String,
      detectedItems: (json['detectedItems'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallConfidence: (json['overallConfidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      requiresManualReview: json['requiresManualReview'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$RecognitionResultImplToJson(
        _$RecognitionResultImpl instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'detectedItems': instance.detectedItems,
      'overallConfidence': instance.overallConfidence,
      'timestamp': instance.timestamp.toIso8601String(),
      'requiresManualReview': instance.requiresManualReview,
      'errorMessage': instance.errorMessage,
    };
