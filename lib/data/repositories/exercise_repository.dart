import '../entities/exercise.dart';

abstract class ExerciseRepository {
  Future<List<Exercise>> getAllExercises();
  Future<List<Exercise>> getExercisesByDateRange(DateTime start, DateTime end);
  Future<List<Exercise>> getExercisesByDate(DateTime date);
  Future<Exercise?> getExerciseById(String id);
  Future<void> saveExercise(Exercise exercise);
  Future<void> updateExercise(Exercise exercise);
  Future<void> deleteExercise(String id);
  Future<void> deleteAllExercises();
  Future<List<Exercise>> getUnsyncedExercises();
  Future<void> markExercisesAsSynced(List<String> exerciseIds);
  Future<double> getTotalCaloriesBurnedForDate(DateTime date);
  Future<List<Exercise>> getExercisesByType(ExerciseType type);
}