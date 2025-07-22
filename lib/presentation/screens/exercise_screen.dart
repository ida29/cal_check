import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/entities/exercise.dart';
import '../../business/providers/exercise_provider.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  bool _useDistance = false; // 距離を使用するかどうか
  
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // よく行う運動
            Text(
              'よく行う運動',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _commonExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _commonExercises[index];
                  return Padding(
                    padding: EdgeInsets.only(right: index < _commonExercises.length - 1 ? 12 : 0),
                    child: _buildExerciseCard(exercise),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            
            // 運動の詳細入力
            Text(
              '運動の詳細',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // 運動名
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '運動名',
                prefixIcon: const Icon(Icons.fitness_center, color: Color(0xFF4CAF50)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 時間/距離選択
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '記録方法を選択',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      RadioListTile<bool>(
                        title: const Text('時間で記録'),
                        value: false,
                        groupValue: _useDistance,
                        onChanged: (value) {
                          setState(() {
                            _useDistance = value!;
                            _distanceController.clear();
                            _durationController.clear();
                            _caloriesController.clear();
                          });
                        },
                      ),
                      RadioListTile<bool>(
                        title: const Text('距離で記録'),
                        value: true,
                        groupValue: _useDistance,
                        onChanged: (value) {
                          setState(() {
                            _useDistance = value!;
                            _distanceController.clear();
                            _durationController.clear();
                            _caloriesController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 時間または距離の入力
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _useDistance ? _distanceController : _durationController,
                    keyboardType: _useDistance 
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.number,
                    inputFormatters: _useDistance
                        ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
                        : [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: _useDistance ? '距離（km）' : '時間（分）',
                      prefixIcon: Icon(
                        _useDistance ? Icons.route : Icons.timer, 
                        color: const Color(0xFF4CAF50)
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                    onChanged: _updateCalories,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _caloriesController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'カロリー（自動計算）',
                      prefixIcon: const Icon(Icons.local_fire_department, color: Color(0xFF4CAF50)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // メモ
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'メモ',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.note, color: Color(0xFF4CAF50)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // 日付選択
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
              title: const Text('日付'),
              subtitle: Text(
                '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
              ),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 32),
            
            // 保存ボタン
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        '運動を記録',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildExerciseCard(Map<String, dynamic> exercise) {
    return InkWell(
      onTap: () {
        setState(() {
          _nameController.text = exercise['name'];
          _updateCaloriesForExercise(exercise['caloriesPerMinute']);
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50).withOpacity(0.1),
              const Color(0xFF4CAF50).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(exercise['icon'], color: const Color(0xFF4CAF50), size: 32),
            const SizedBox(height: 8),
            Text(
              exercise['name'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  
  void _updateCalories(String value) {
    if (value.isEmpty || _nameController.text.isEmpty) return;
    
    // 運動名から基準カロリーを取得
    final exercise = _commonExercises.firstWhere(
      (e) => e['name'] == _nameController.text,
      orElse: () => {'caloriesPerMinute': 5},
    );
    final baseCalories = exercise['caloriesPerMinute'] as int;
    
    int calories = 0;
    if (_useDistance) {
      // 距離ベースの計算
      final distance = double.tryParse(value) ?? 0.0;
      // 距離(km) × 基準カロリー/分 × 推定時間(分/km)
      // 例: ウォーキング 12分/km、ランニング 6分/km
      double timePerKm = 10; // デフォルト
      switch (_nameController.text) {
        case 'ウォーキング':
          timePerKm = 12;
          break;
        case 'ランニング':
          timePerKm = 6;
          break;
        case 'サイクリング':
          timePerKm = 4;
          break;
        default:
          timePerKm = 10;
          break;
      }
      final estimatedMinutes = distance * timePerKm;
      calories = (estimatedMinutes * baseCalories).round();
    } else {
      // 時間ベースの計算
      final minutes = int.tryParse(value) ?? 0;
      calories = (minutes * baseCalories).round();
    }
    
    _caloriesController.text = calories.toString();
  }
  
  void _updateCaloriesForExercise(int caloriesPerMinute) {
    String currentValue = _useDistance ? _distanceController.text : _durationController.text;
    if (currentValue.isEmpty) return;
    
    int calories = 0;
    if (_useDistance) {
      // 距離ベースの計算
      final distance = double.tryParse(currentValue) ?? 0.0;
      double timePerKm = 10;
      switch (_nameController.text) {
        case 'ウォーキング':
          timePerKm = 12;
          break;
        case 'ランニング':
          timePerKm = 6;
          break;
        case 'サイクリング':
          timePerKm = 4;
          break;
        default:
          timePerKm = 10;
          break;
      }
      final estimatedMinutes = distance * timePerKm;
      calories = (estimatedMinutes * caloriesPerMinute).round();
    } else {
      // 時間ベースの計算
      final minutes = int.tryParse(currentValue) ?? 0;
      calories = (minutes * caloriesPerMinute).round();
    }
    
    _caloriesController.text = calories.toString();
  }
  
  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  Future<void> _saveExercise() async {
    String currentValue = _useDistance ? _distanceController.text : _durationController.text;
    String fieldName = _useDistance ? '距離' : '時間';
    
    if (_nameController.text.isEmpty || currentValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('運動名と${fieldName}を入力してください')),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final recordedAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
      );
      
      // 運動タイプを決定
      ExerciseType exerciseType = ExerciseType.cardio;
      final name = _nameController.text.toLowerCase();
      if (name.contains('ウォーキング') || name.contains('歩')) {
        exerciseType = ExerciseType.walking;
      } else if (name.contains('ランニング') || name.contains('走')) {
        exerciseType = ExerciseType.running;
      } else if (name.contains('サイクリング') || name.contains('自転車')) {
        exerciseType = ExerciseType.cycling;
      } else if (name.contains('水泳') || name.contains('プール')) {
        exerciseType = ExerciseType.swimming;
      } else if (name.contains('筋トレ')) {
        exerciseType = ExerciseType.strength;
      } else if (name.contains('ヨガ')) {
        exerciseType = ExerciseType.flexibility;
      }
      
      final exercise = Exercise(
        id: const Uuid().v4(),
        timestamp: recordedAt,
        type: exerciseType,
        name: _nameController.text,
        durationMinutes: _useDistance ? 0 : int.tryParse(_durationController.text) ?? 0,
        caloriesBurned: double.tryParse(_caloriesController.text) ?? 0.0,
        intensity: ExerciseIntensity.moderate, // デフォルト中強度
        notes: _noteController.text.isNotEmpty ? _noteController.text : null,
        distance: _useDistance ? double.tryParse(_distanceController.text) : null,
        isManualEntry: true,
      );
      
      await ref.read(exercisesProvider.notifier).saveExercise(exercise);
      
      // 選択した日付のプロバイダーを更新
      await ref.read(exercisesByDateProvider(_selectedDate).notifier).refreshExercises();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text}を記録しました（${_caloriesController.text}カロリー消費）'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        
        // 履歴画面へ遷移
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/main',
          (route) => false,
          arguments: {'initialIndex': 1}, // 履歴タブ（インデックス1）
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  
  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _distanceController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}