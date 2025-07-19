import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../business/providers/exercise_provider.dart';
import '../../data/entities/exercise.dart';
import 'exercise_entry_screen.dart';

class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesByDateProvider(DateTime.now()));
    final totalCaloriesAsync = ref.watch(totalCaloriesBurnedProvider(DateTime.now()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('運動記録'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ExerciseEntryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Daily summary card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日の運動',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  totalCaloriesAsync.when(
                    data: (calories) => Text(
                      '消費カロリー: ${calories.toStringAsFixed(0)} kcal',
                      style: const TextStyle(fontSize: 16),
                    ),
                    loading: () => const Text('読み込み中...'),
                    error: (error, _) => Text('エラー: $error'),
                  ),
                ],
              ),
            ),
          ),
          // Exercise list
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                if (exercises.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          '運動記録がありません',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '右上の + ボタンから運動を記録しましょう',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ExerciseCard(exercise: exercise);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('エラーが発生しました: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseCard extends ConsumerWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getExerciseTypeColor(exercise.type),
          child: Icon(
            _getExerciseTypeIcon(exercise.type),
            color: Colors.white,
          ),
        ),
        title: Text(exercise.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${exercise.durationMinutes}分 • ${exercise.caloriesBurned.toStringAsFixed(0)}kcal'),
            Text(_getIntensityText(exercise.intensity)),
            if (exercise.notes?.isNotEmpty == true)
              Text('メモ: ${exercise.notes}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('編集'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('削除'),
            ),
          ],
          onSelected: (value) async {
            if (value == 'edit') {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExerciseEntryScreen(exercise: exercise),
                ),
              );
            } else if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('削除確認'),
                  content: const Text('この運動記録を削除しますか？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('キャンセル'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('削除'),
                    ),
                  ],
                ),
              );
              
              if (confirmed == true) {
                ref.read(exercisesProvider.notifier).deleteExercise(exercise.id);
              }
            }
          },
        ),
      ),
    );
  }

  Color _getExerciseTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.cardio:
        return Colors.red;
      case ExerciseType.strength:
        return Colors.blue;
      case ExerciseType.flexibility:
        return Colors.green;
      case ExerciseType.sports:
        return Colors.orange;
      case ExerciseType.walking:
        return Colors.purple;
      case ExerciseType.running:
        return Colors.deepOrange;
      case ExerciseType.cycling:
        return Colors.teal;
      case ExerciseType.swimming:
        return Colors.cyan;
      case ExerciseType.other:
        return Colors.grey;
    }
  }

  IconData _getExerciseTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.cardio:
        return Icons.favorite;
      case ExerciseType.strength:
        return Icons.fitness_center;
      case ExerciseType.flexibility:
        return Icons.self_improvement;
      case ExerciseType.sports:
        return Icons.sports;
      case ExerciseType.walking:
        return Icons.directions_walk;
      case ExerciseType.running:
        return Icons.directions_run;
      case ExerciseType.cycling:
        return Icons.directions_bike;
      case ExerciseType.swimming:
        return Icons.pool;
      case ExerciseType.other:
        return Icons.fitness_center;
    }
  }

  String _getIntensityText(ExerciseIntensity intensity) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return '軽度';
      case ExerciseIntensity.moderate:
        return '中程度';
      case ExerciseIntensity.high:
        return '高強度';
    }
  }
}