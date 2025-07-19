import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../business/providers/exercise_provider.dart';
import '../../data/entities/exercise.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.exercise != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editExercise : l10n.addExercise),
        backgroundColor: const Color(0xFFFFC1CC),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveExercise,
            child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
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
              decoration: InputDecoration(
                labelText: l10n.exerciseName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterExerciseName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Exercise type
            DropdownButtonFormField<ExerciseType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.exerciseType,
                border: const OutlineInputBorder(),
              ),
              items: ExerciseType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getExerciseTypeName(type, l10n)),
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
                    decoration: InputDecoration(
                      labelText: l10n.durationMinutes,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterDuration;
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return l10n.pleaseEnterValidDuration;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    decoration: InputDecoration(
                      labelText: l10n.caloriesBurned,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterCalories;
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return l10n.pleaseEnterValidCalories;
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
              decoration: InputDecoration(
                labelText: l10n.intensity,
                border: const OutlineInputBorder(),
              ),
              items: ExerciseIntensity.values.map((intensity) {
                return DropdownMenuItem(
                  value: intensity,
                  child: Text(_getIntensityName(intensity, l10n)),
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
              Text(
                l10n.strengthTrainingDetails,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: InputDecoration(
                        labelText: l10n.sets,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: InputDecoration(
                        labelText: l10n.reps,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: l10n.weightKg,
                  border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: l10n.distanceKm,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Date and time picker
            ListTile(
              title: Text(l10n.dateTime),
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
              decoration: InputDecoration(
                labelText: l10n.notesOptional,
                border: const OutlineInputBorder(),
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
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.error}: $error')),
        );
      }
    }
  }

  String _getExerciseTypeName(ExerciseType type, AppLocalizations l10n) {
    switch (type) {
      case ExerciseType.cardio:
        return l10n.cardio;
      case ExerciseType.strength:
        return l10n.strength;
      case ExerciseType.flexibility:
        return l10n.flexibility;
      case ExerciseType.sports:
        return l10n.sports;
      case ExerciseType.walking:
        return l10n.walking;
      case ExerciseType.running:
        return l10n.running;
      case ExerciseType.cycling:
        return l10n.cycling;
      case ExerciseType.swimming:
        return l10n.swimming;
      case ExerciseType.other:
        return l10n.other;
    }
  }

  String _getIntensityName(ExerciseIntensity intensity, AppLocalizations l10n) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return l10n.lowIntensity;
      case ExerciseIntensity.moderate:
        return l10n.moderateIntensity;
      case ExerciseIntensity.high:
        return l10n.highIntensity;
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