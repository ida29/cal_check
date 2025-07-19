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
            
            // 時間とカロリー
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: '時間（分）',
                      prefixIcon: const Icon(Icons.timer, color: Color(0xFF4CAF50)),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'カロリー',
                      prefixIcon: const Icon(Icons.local_fire_department, color: Color(0xFF4CAF50)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 強度選択
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      Text(
                        '運動強度',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIntensityOption('low', '軽い', Icons.spa),
                      _buildIntensityOption('moderate', '普通', Icons.directions_walk),
                      _buildIntensityOption('high', '激しい', Icons.directions_run),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // 日付選択
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF4CAF50)),
              title: const Text('日付'),
              subtitle: Text(
                '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _selectDate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            const SizedBox(height: 32),
            
            // 保存ボタン
            ElevatedButton(
              onPressed: _saveExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '運動を記録',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
  
  Widget _buildIntensityOption(String value, String label, IconData icon) {
    final isSelected = _selectedIntensity == value;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIntensity = value;
          _updateCalories(_durationController.text);
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _updateCalories(String duration) {
    if (duration.isEmpty) return;
    
    final minutes = int.tryParse(duration) ?? 0;
    int baseCalories = 5; // デフォルトのカロリー/分
    
    // 運動名から基準カロリーを取得
    final exercise = _commonExercises.firstWhere(
      (e) => e['name'] == _nameController.text,
      orElse: () => {'caloriesPerMinute': 5},
    );
    baseCalories = exercise['caloriesPerMinute'] as int;
    
    // 強度による調整
    double multiplier = 1.0;
    switch (_selectedIntensity) {
      case 'low':
        multiplier = 0.8;
        break;
      case 'moderate':
        multiplier = 1.0;
        break;
      case 'high':
        multiplier = 1.3;
        break;
    }
    
    final calories = (minutes * baseCalories * multiplier).round();
    _caloriesController.text = calories.toString();
  }
  
  void _updateCaloriesForExercise(int caloriesPerMinute) {
    if (_durationController.text.isEmpty) return;
    
    final minutes = int.tryParse(_durationController.text) ?? 0;
    double multiplier = 1.0;
    
    switch (_selectedIntensity) {
      case 'low':
        multiplier = 0.8;
        break;
      case 'moderate':
        multiplier = 1.0;
        break;
      case 'high':
        multiplier = 1.3;
        break;
    }
    
    final calories = (minutes * caloriesPerMinute * multiplier).round();
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
  
  void _saveExercise() {
    if (_nameController.text.isEmpty || _durationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('運動名と時間を入力してください')),
      );
      return;
    }
    
    // TODO: 実際の保存処理を実装
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameController.text}を記録しました（${_caloriesController.text}カロリー消費）'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
    
    // 入力をクリア
    _nameController.clear();
    _durationController.clear();
    _caloriesController.clear();
    setState(() {
      _selectedIntensity = 'moderate';
    });
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }
}