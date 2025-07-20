import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/entities/weight_record.dart';
import '../../business/services/record_storage_service.dart';
import '../../business/services/setup_service.dart';
import '../../business/providers/meal_provider.dart';
import '../../data/entities/meal.dart';

class WeightTrackingScreen extends ConsumerStatefulWidget {
  const WeightTrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends ConsumerState<WeightTrackingScreen> {
  final _recordStorageService = RecordStorageService();
  final _setupService = SetupService();
  
  List<WeightRecord> _records = [];
  bool _isLoading = true;
  int _selectedPeriod = 30; // days
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: _selectedPeriod));
    
    final records = await _recordStorageService.getWeightRecordsByDateRange(
      startDate: startDate,
      endDate: endDate,
    );
    
    final userProfile = await _setupService.getUserProfile();
    
    setState(() {
      _records = records;
      _userProfile = userProfile;
      _isLoading = false;
    });
  }

  void _showAddWeightDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddWeightDialog(
        onSaved: () {
          _loadData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddWeightDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 20),
                  _buildWeightChart(),
                  const SizedBox(height: 20),
                  _buildBodyFatChart(),
                  const SizedBox(height: 20),
                  _buildStatistics(),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PeriodChip(
          label: '1週間',
          selected: _selectedPeriod == 7,
          onSelected: () {
            setState(() => _selectedPeriod = 7);
            _loadData();
          },
        ),
        const SizedBox(width: 8),
        _PeriodChip(
          label: '1ヶ月',
          selected: _selectedPeriod == 30,
          onSelected: () {
            setState(() => _selectedPeriod = 30);
            _loadData();
          },
        ),
        const SizedBox(width: 8),
        _PeriodChip(
          label: '3ヶ月',
          selected: _selectedPeriod == 90,
          onSelected: () {
            setState(() => _selectedPeriod = 90);
            _loadData();
          },
        ),
        const SizedBox(width: 8),
        _PeriodChip(
          label: '1年',
          selected: _selectedPeriod == 365,
          onSelected: () {
            setState(() => _selectedPeriod = 365);
            _loadData();
          },
        ),
      ],
    );
  }

  Widget _buildWeightChart() {
    if (_records.isEmpty) {
      return Card(
        child: Container(
          height: 300,
          alignment: Alignment.center,
          child: const Text('データがありません'),
        ),
      );
    }

    final minWeight = _records.map((r) => r.weight).reduce((a, b) => a < b ? a : b) - 5;
    final maxWeight = _records.map((r) => r.weight).reduce((a, b) => a > b ? a : b) + 5;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '体重推移',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < _records.length) {
                            final date = _records[value.toInt()].recordedAt;
                            if (_selectedPeriod <= 7) {
                              return Text(
                                '${date.month}/${date.day}',
                                style: const TextStyle(fontSize: 10),
                              );
                            } else if (_selectedPeriod <= 30) {
                              if (value.toInt() % 5 == 0) {
                                return Text(
                                  '${date.month}/${date.day}',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                            } else {
                              if (value.toInt() % 30 == 0) {
                                return Text(
                                  '${date.month}月',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _records.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.weight);
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: _records.length <= 30,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Theme.of(context).primaryColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: minWeight,
                  maxY: maxWeight,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toStringAsFixed(1)}kg',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyFatChart() {
    final bodyFatRecords = _records.where((r) => r.bodyFat != null).toList();
    
    if (bodyFatRecords.isEmpty) {
      return const SizedBox.shrink();
    }

    final minBodyFat = bodyFatRecords.map((r) => r.bodyFat!).reduce((a, b) => a < b ? a : b) - 2;
    final maxBodyFat = bodyFatRecords.map((r) => r.bodyFat!).reduce((a, b) => a > b ? a : b) + 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '体脂肪率推移',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey[300]!,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toStringAsFixed(0)}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final recordIndex = _records.indexWhere((r) => 
                            r.bodyFat != null && 
                            _records.where((r2) => r2.bodyFat != null).toList().indexOf(r) == value.toInt()
                          );
                          if (recordIndex >= 0) {
                            final date = _records[recordIndex].recordedAt;
                            if (_selectedPeriod <= 30) {
                              return Text(
                                '${date.month}/${date.day}',
                                style: const TextStyle(fontSize: 10),
                              );
                            } else {
                              if (value.toInt() % 2 == 0) {
                                return Text(
                                  '${date.month}月',
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: bodyFatRecords.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value.bodyFat!);
                      }).toList(),
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: bodyFatRecords.length <= 30,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.orange,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.orange.withOpacity(0.1),
                      ),
                    ),
                  ],
                  minY: minBodyFat,
                  maxY: maxBodyFat,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          return LineTooltipItem(
                            '${barSpot.y.toStringAsFixed(1)}%',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    if (_records.isEmpty) return const SizedBox.shrink();
    
    final latestWeight = _records.last.weight;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '現在',
                  '${latestWeight.toStringAsFixed(1)}kg',
                  Theme.of(context).primaryColor,
                ),
                if (_userProfile?.targetWeight != null)
                  _buildStatItem(
                    '目標',
                    '${_userProfile!.targetWeight!.toStringAsFixed(1)}kg',
                    Colors.green,
                  ),
                if (_userProfile?.targetWeight != null)
                  _buildStatItem(
                    '目標まで',
                    '${(latestWeight - _userProfile!.targetWeight!).abs().toStringAsFixed(1)}kg',
                    Colors.orange,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: selected ? Colors.white : null,
      ),
    );
  }
}

class _AddWeightDialog extends ConsumerStatefulWidget {
  final VoidCallback onSaved;

  const _AddWeightDialog({required this.onSaved});

  @override
  ConsumerState<_AddWeightDialog> createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends ConsumerState<_AddWeightDialog> {
  final _formKey = GlobalKey<FormState>();
  final _recordStorageService = RecordStorageService();
  final _setupService = SetupService();
  
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final recordedAt = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      
      final record = WeightRecord(
        id: const Uuid().v4(),
        recordedAt: recordedAt,
        weight: double.parse(_weightController.text),
        bodyFat: _bodyFatController.text.isNotEmpty
            ? double.tryParse(_bodyFatController.text)
            : null,
        muscleMass: _muscleMassController.text.isNotEmpty
            ? double.tryParse(_muscleMassController.text)
            : null,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
        createdAt: DateTime.now(),
      );
      
      await _recordStorageService.saveWeightRecord(record);
      
      // Update user profile with new weight
      final profile = await _setupService.getUserProfile();
      if (profile != null) {
        await _setupService.updateUserProfile(
          profile.copyWith(weight: record.weight),
        );
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('体重を記録しました'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSaved();
        Navigator.of(context).pop();
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
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '体重記録',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '日付',
                              prefixIcon: Icon(Icons.calendar_today),
                              isDense: true,
                            ),
                            child: Text(
                              '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() => _selectedTime = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: '時刻',
                              prefixIcon: Icon(Icons.access_time),
                              isDense: true,
                            ),
                            child: Text(
                              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: '体重',
                      suffixText: 'kg',
                      hintText: '例: 65.5',
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '体重を入力してください';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0 || weight > 300) {
                        return '正しい体重を入力してください';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bodyFatController,
                    decoration: const InputDecoration(
                      labelText: '体脂肪率（任意）',
                      suffixText: '%',
                      hintText: '例: 20.5',
                      prefixIcon: Icon(Icons.percent),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _muscleMassController,
                    decoration: const InputDecoration(
                      labelText: '筋肉量（任意）',
                      suffixText: 'kg',
                      hintText: '例: 50.0',
                      prefixIcon: Icon(Icons.fitness_center),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                      labelText: 'メモ（任意）',
                      hintText: '体調や食事の記録など',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('キャンセル'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveWeight,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('記録する'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}