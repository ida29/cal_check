import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../business/providers/exercise_provider.dart';
import '../../data/entities/exercise.dart';

class ExerciseEntryScreen extends ConsumerStatefulWidget {
  final Exercise? exercise;

  const ExerciseEntryScreen({super.key, this.exercise});

  @override
  ConsumerState<ExerciseEntryScreen> createState() => _ExerciseEntryScreenState();
}

class _ExerciseEntryScreenState extends ConsumerState<ExerciseEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _distanceController = TextEditingController();

  ExerciseType _selectedType = ExerciseType.cardio;
  ExerciseIntensity _selectedIntensity = ExerciseIntensity.moderate;
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.exercise != null) {
      _initializeFromExercise(widget.exercise!);
    }
  }

  void _initializeFromExercise(Exercise exercise) {
    _nameController.text = exercise.name;
    _durationController.text = exercise.durationMinutes.toString();
    _caloriesController.text = exercise.caloriesBurned.toString();
    _notesController.text = exercise.notes ?? '';
    _setsController.text = exercise.sets?.toString() ?? '';
    _repsController.text = exercise.reps?.toString() ?? '';
    _weightController.text = exercise.weight?.toString() ?? '';
    _distanceController.text = exercise.distance?.toString() ?? '';
    _selectedType = exercise.type;
    _selectedIntensity = exercise.intensity;
    _selectedDateTime = exercise.timestamp;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.exercise != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '運動記録を編集' : '運動記録を追加'),
        actions: [
          TextButton(
            onPressed: _saveExercise,
            child: const Text('保存', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Exercise name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '運動名',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '運動名を入力してください';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Exercise type
            DropdownButtonFormField<ExerciseType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: '運動種類',
                border: OutlineInputBorder(),
              ),
              items: ExerciseType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getExerciseTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Duration and calories row
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: '時間（分）',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '時間を入力してください';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return '正しい時間を入力してください';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    decoration: const InputDecoration(
                      labelText: '消費カロリー',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'カロリーを入力してください';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return '正しいカロリーを入力してください';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Intensity
            DropdownButtonFormField<ExerciseIntensity>(
              value: _selectedIntensity,
              decoration: const InputDecoration(
                labelText: '強度',
                border: OutlineInputBorder(),
              ),
              items: ExerciseIntensity.values.map((intensity) {
                return DropdownMenuItem(
                  value: intensity,
                  child: Text(_getIntensityName(intensity)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIntensity = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Optional fields for strength training
            if (_selectedType == ExerciseType.strength) ...[
              const Text(
                '筋力トレーニング詳細',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: 'セット数',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: const InputDecoration(
                        labelText: '回数',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: '重量（kg）',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Optional distance field for cardio
            if (_selectedType == ExerciseType.running ||
                _selectedType == ExerciseType.cycling ||
                _selectedType == ExerciseType.walking ||
                _selectedType == ExerciseType.swimming) ...[
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: '距離（km）',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Date and time picker
            ListTile(
              title: const Text('日時'),
              subtitle: Text(
                '${_selectedDateTime.year}/${_selectedDateTime.month}/${_selectedDateTime.day} '
                '${_selectedDateTime.hour.toString().padLeft(2, '0')}:'
                '${_selectedDateTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'メモ（任意）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveExercise() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercise = Exercise(
      id: widget.exercise?.id ?? const Uuid().v4(),
      timestamp: _selectedDateTime,
      type: _selectedType,
      name: _nameController.text,
      durationMinutes: int.parse(_durationController.text),
      caloriesBurned: double.parse(_caloriesController.text),
      intensity: _selectedIntensity,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      sets: _setsController.text.isEmpty ? null : int.tryParse(_setsController.text),
      reps: _repsController.text.isEmpty ? null : int.tryParse(_repsController.text),
      weight: _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
      distance: _distanceController.text.isEmpty ? null : double.tryParse(_distanceController.text),
      isManualEntry: true,
    );

    try {
      if (widget.exercise != null) {
        await ref.read(exercisesProvider.notifier).updateExercise(exercise);
      } else {
        await ref.read(exercisesProvider.notifier).saveExercise(exercise);
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラーが発生しました: $error')),
        );
      }
    }
  }

  String _getExerciseTypeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.cardio:
        return '有酸素運動';
      case ExerciseType.strength:
        return '筋力トレーニング';
      case ExerciseType.flexibility:
        return 'ストレッチ・柔軟性';
      case ExerciseType.sports:
        return 'スポーツ';
      case ExerciseType.walking:
        return 'ウォーキング';
      case ExerciseType.running:
        return 'ランニング';
      case ExerciseType.cycling:
        return 'サイクリング';
      case ExerciseType.swimming:
        return '水泳';
      case ExerciseType.other:
        return 'その他';
    }
  }

  String _getIntensityName(ExerciseIntensity intensity) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return '軽度';
      case ExerciseIntensity.moderate:
        return '中程度';
      case ExerciseIntensity.high:
        return '高強度';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _distanceController.dispose();
    super.dispose();
  }
}