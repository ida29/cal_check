import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  
  String _selectedIntensity = 'moderate';
  DateTime _selectedDate = DateTime.now();
  
  final List<Map<String, dynamic>> _commonExercises = [
    {'name': 'ウォーキング', 'icon': Icons.directions_walk, 'caloriesPerMinute': 5},
    {'name': 'ランニング', 'icon': Icons.directions_run, 'caloriesPerMinute': 10},
    {'name': 'サイクリング', 'icon': Icons.directions_bike, 'caloriesPerMinute': 8},
    {'name': '水泳', 'icon': Icons.pool, 'caloriesPerMinute': 11},
    {'name': 'ヨガ', 'icon': Icons.self_improvement, 'caloriesPerMinute': 3},
    {'name': '筋トレ', 'icon': Icons.fitness_center, 'caloriesPerMinute': 6},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('運動を記録'),
        centerTitle: true,
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
                  Text(
                    l10n.todaysExercise,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  totalCaloriesAsync.when(
                    data: (calories) => Text(
                      '${l10n.caloriesBurned}: ${calories.toStringAsFixed(0)} ${l10n.caloriesUnit}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    loading: () => Text(l10n.loading),
                    error: (error, _) => Text('${l10n.error}: $error'),
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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noExerciseRecords,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addExerciseHint,
                          style: const TextStyle(color: Colors.grey),
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
                child: Text('${l10n.error}: $error'),
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
    final l10n = AppLocalizations.of(context)!;
    
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
            Text('${exercise.durationMinutes}${l10n.minutesUnit} • ${exercise.caloriesBurned.toStringAsFixed(0)}${l10n.caloriesUnit}'),
            Text(_getIntensityText(exercise.intensity, l10n)),
            if (exercise.notes?.isNotEmpty == true)
              Text('${l10n.notes}: ${exercise.notes}', style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              child: Text(l10n.edit),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete),
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
                  title: Text(l10n.confirmDelete),
                  content: Text(l10n.confirmDeleteExercise),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(l10n.delete),
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

  String _getIntensityText(ExerciseIntensity intensity, AppLocalizations l10n) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return l10n.lowIntensity;
      case ExerciseIntensity.moderate:
        return l10n.moderateIntensity;
      case ExerciseIntensity.high:
        return l10n.highIntensity;
    }
  }
}