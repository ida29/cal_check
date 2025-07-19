import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/entities/meal_record.dart';
import '../../data/entities/exercise_record.dart';
import '../../data/entities/weight_record.dart';

class RecordStorageService {
  static final RecordStorageService _instance = RecordStorageService._internal();
  factory RecordStorageService() => _instance;
  RecordStorageService._internal();

  static const String _mealRecordsKey = 'meal_records';
  static const String _exerciseRecordsKey = 'exercise_records';
  static const String _weightRecordsKey = 'weight_records';

  // Meal Records
  Future<List<MealRecord>> getMealRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_mealRecordsKey) ?? [];
    
    return recordsJson.map((json) {
      try {
        return MealRecord.fromJson(jsonDecode(json));
      } catch (e) {
        print('Error parsing meal record: $e');
        return null;
      }
    }).whereType<MealRecord>().toList();
  }

  Future<void> saveMealRecord(MealRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getMealRecords();
    
    records.add(record);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_mealRecordsKey, recordsJson);
  }

  Future<void> updateMealRecord(MealRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getMealRecords();
    
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_mealRecordsKey, recordsJson);
    }
  }

  Future<void> deleteMealRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getMealRecords();
    
    records.removeWhere((r) => r.id == id);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_mealRecordsKey, recordsJson);
  }

  Future<List<MealRecord>> getMealRecordsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allRecords = await getMealRecords();
    return allRecords.where((record) {
      return record.recordedAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
             record.recordedAt.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  // Exercise Records
  Future<List<ExerciseRecord>> getExerciseRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_exerciseRecordsKey) ?? [];
    
    return recordsJson.map((json) {
      try {
        return ExerciseRecord.fromJson(jsonDecode(json));
      } catch (e) {
        print('Error parsing exercise record: $e');
        return null;
      }
    }).whereType<ExerciseRecord>().toList();
  }

  Future<void> saveExerciseRecord(ExerciseRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getExerciseRecords();
    
    records.add(record);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_exerciseRecordsKey, recordsJson);
  }

  Future<void> updateExerciseRecord(ExerciseRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getExerciseRecords();
    
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_exerciseRecordsKey, recordsJson);
    }
  }

  Future<void> deleteExerciseRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getExerciseRecords();
    
    records.removeWhere((r) => r.id == id);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_exerciseRecordsKey, recordsJson);
  }

  Future<List<ExerciseRecord>> getExerciseRecordsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allRecords = await getExerciseRecords();
    return allRecords.where((record) {
      return record.recordedAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
             record.recordedAt.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  // Weight Records
  Future<List<WeightRecord>> getWeightRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordsJson = prefs.getStringList(_weightRecordsKey) ?? [];
    
    return recordsJson.map((json) {
      try {
        return WeightRecord.fromJson(jsonDecode(json));
      } catch (e) {
        print('Error parsing weight record: $e');
        return null;
      }
    }).whereType<WeightRecord>().toList();
  }

  Future<void> saveWeightRecord(WeightRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getWeightRecords();
    
    records.add(record);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_weightRecordsKey, recordsJson);
  }

  Future<void> updateWeightRecord(WeightRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getWeightRecords();
    
    final index = records.indexWhere((r) => r.id == record.id);
    if (index != -1) {
      records[index] = record;
      final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList(_weightRecordsKey, recordsJson);
    }
  }

  Future<void> deleteWeightRecord(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getWeightRecords();
    
    records.removeWhere((r) => r.id == id);
    
    final recordsJson = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_weightRecordsKey, recordsJson);
  }

  Future<List<WeightRecord>> getWeightRecordsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allRecords = await getWeightRecords();
    return allRecords.where((record) {
      return record.recordedAt.isAfter(startDate.subtract(const Duration(seconds: 1))) &&
             record.recordedAt.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  Future<WeightRecord?> getLatestWeightRecord() async {
    final records = await getWeightRecords();
    if (records.isEmpty) return null;
    
    records.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    return records.first;
  }

  // Clear all records
  Future<void> clearAllRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_mealRecordsKey);
    await prefs.remove(_exerciseRecordsKey);
    await prefs.remove(_weightRecordsKey);
  }
}