import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/exercise.dart';
import '../../data/repositories/exercise_repository.dart';
import '../../data/datasources/exercise_repository_impl.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return ExerciseRepositoryImpl();
});

final exercisesProvider = StateNotifierProvider<ExerciseNotifier, AsyncValue<List<Exercise>>>((ref) {
  return ExerciseNotifier(ref.watch(exerciseRepositoryProvider));
});

final exercisesByDateProvider = StateNotifierProvider.family<ExercisesByDateNotifier, AsyncValue<List<Exercise>>, DateTime>((ref, date) {
  return ExercisesByDateNotifier(ref.watch(exerciseRepositoryProvider), date);
});

final totalCaloriesBurnedProvider = StateNotifierProvider.family<CaloriesBurnedNotifier, AsyncValue<double>, DateTime>((ref, date) {
  return CaloriesBurnedNotifier(ref.watch(exerciseRepositoryProvider), date);
});

class ExerciseNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final ExerciseRepository _exerciseRepository;

  ExerciseNotifier(this._exerciseRepository) : super(const AsyncValue.loading()) {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _exerciseRepository.getAllExercises();
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveExercise(Exercise exercise) async {
    try {
      await _exerciseRepository.saveExercise(exercise);
      await _loadExercises(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _exerciseRepository.updateExercise(exercise);
      await _loadExercises(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _exerciseRepository.deleteExercise(id);
      await _loadExercises(); // Refresh the list
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshExercises() async {
    await _loadExercises();
  }
}

class ExercisesByDateNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final ExerciseRepository _exerciseRepository;
  final DateTime _date;

  ExercisesByDateNotifier(this._exerciseRepository, this._date) : super(const AsyncValue.loading()) {
    _loadExercisesByDate();
  }

  Future<void> _loadExercisesByDate() async {
    try {
      final exercises = await _exerciseRepository.getExercisesByDate(_date);
      state = AsyncValue.data(exercises);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshExercises() async {
    await _loadExercisesByDate();
  }
}

class CaloriesBurnedNotifier extends StateNotifier<AsyncValue<double>> {
  final ExerciseRepository _exerciseRepository;
  final DateTime _date;

  CaloriesBurnedNotifier(this._exerciseRepository, this._date) : super(const AsyncValue.loading()) {
    _loadCaloriesBurned();
  }

  Future<void> _loadCaloriesBurned() async {
    try {
      final calories = await _exerciseRepository.getTotalCaloriesBurnedForDate(_date);
      state = AsyncValue.data(calories);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshCaloriesBurned() async {
    await _loadCaloriesBurned();
  }
}