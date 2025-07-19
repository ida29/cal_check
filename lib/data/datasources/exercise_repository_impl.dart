import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../entities/exercise.dart';
import '../repositories/exercise_repository.dart';
import 'database_helper.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Exercise>> getAllExercises() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'exercises',
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => _mapToExercise(map)).toList();
  }

  @override
  Future<List<Exercise>> getExercisesByDateRange(DateTime start, DateTime end) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'exercises',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => _mapToExercise(map)).toList();
  }

  @override
  Future<List<Exercise>> getExercisesByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return getExercisesByDateRange(startOfDay, endOfDay);
  }

  @override
  Future<Exercise?> getExerciseById(String id) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return _mapToExercise(maps.first);
  }

  @override
  Future<void> saveExercise(Exercise exercise) async {
    final db = await _databaseHelper.database;
    await db.insert(
      'exercises',
      _exerciseToMap(exercise),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateExercise(Exercise exercise) async {
    final db = await _databaseHelper.database;
    await db.update(
      'exercises',
      _exerciseToMap(exercise),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  @override
  Future<void> deleteExercise(String id) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'exercises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllExercises() async {
    final db = await _databaseHelper.database;
    await db.delete('exercises');
  }

  @override
  Future<List<Exercise>> getUnsyncedExercises() async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'exercises',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => _mapToExercise(map)).toList();
  }

  @override
  Future<void> markExercisesAsSynced(List<String> exerciseIds) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();
    
    for (final id in exerciseIds) {
      batch.update(
        'exercises',
        {'is_synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<double> getTotalCaloriesBurnedForDate(DateTime date) async {
    final exercises = await getExercisesByDate(date);
    return exercises.fold(0.0, (sum, exercise) => sum + exercise.caloriesBurned);
  }

  @override
  Future<List<Exercise>> getExercisesByType(ExerciseType type) async {
    final db = await _databaseHelper.database;
    final maps = await db.query(
      'exercises',
      where: 'type = ?',
      whereArgs: [type.name],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => _mapToExercise(map)).toList();
  }

  Exercise _mapToExercise(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      type: ExerciseType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ExerciseType.other,
      ),
      name: map['name'] as String,
      durationMinutes: map['duration_minutes'] as int,
      caloriesBurned: map['calories_burned'] as double,
      intensity: ExerciseIntensity.values.firstWhere(
        (e) => e.name == map['intensity'],
        orElse: () => ExerciseIntensity.moderate,
      ),
      notes: map['notes'] as String?,
      sets: map['sets'] as int?,
      reps: map['reps'] as int?,
      weight: map['weight'] as double?,
      distance: map['distance'] as double?,
      isSynced: (map['is_synced'] as int) == 1,
      isManualEntry: (map['is_manual_entry'] as int) == 1,
    );
  }

  Map<String, dynamic> _exerciseToMap(Exercise exercise) {
    return {
      'id': exercise.id,
      'timestamp': exercise.timestamp.toIso8601String(),
      'type': exercise.type.name,
      'name': exercise.name,
      'duration_minutes': exercise.durationMinutes,
      'calories_burned': exercise.caloriesBurned,
      'intensity': exercise.intensity.name,
      'notes': exercise.notes,
      'sets': exercise.sets,
      'reps': exercise.reps,
      'weight': exercise.weight,
      'distance': exercise.distance,
      'is_synced': exercise.isSynced ? 1 : 0,
      'is_manual_entry': exercise.isManualEntry ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}