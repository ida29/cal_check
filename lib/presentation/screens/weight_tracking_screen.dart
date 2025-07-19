import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/entities/weight_record.dart';
import '../../business/services/record_storage_service.dart';
import '../../business/services/setup_service.dart';

class WeightTrackingScreen extends ConsumerStatefulWidget {
  const WeightTrackingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightTrackingScreen> createState() => _WeightTrackingScreenState();
}

class _WeightTrackingScreenState extends ConsumerState<WeightTrackingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _recordStorageService = RecordStorageService();
  final _setupService = SetupService();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '体重記録'),
            Tab(text: '推移グラフ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WeightRecordTab(),
          _WeightGraphTab(),
        ],
      ),
    );
  }
}

class _WeightRecordTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_WeightRecordTab> createState() => _WeightRecordTabState();
}

class _WeightRecordTabState extends ConsumerState<_WeightRecordTab> {
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
  WeightRecord? _latestRecord;

  @override
  void initState() {
    super.initState();
    _loadLatestRecord();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadLatestRecord() async {
    final record = await _recordStorageService.getLatestWeightRecord();
    if (record != null && mounted) {
      setState(() {
        _latestRecord = record;
        _weightController.text = record.weight.toStringAsFixed(1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_latestRecord != null) _buildLatestRecordCard(),
              const SizedBox(height: 16),
              _buildDateTimeSelector(),
              const SizedBox(height: 16),
              _buildWeightInput(),
              const SizedBox(height: 16),
              _buildBodyCompositionInputs(),
              const SizedBox(height: 16),
              _buildNoteInput(),
              const SizedBox(height: 24),
              _buildBMIDisplay(),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveWeight,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator()
                      : const Text(
                          '記録する',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLatestRecordCard() {
    final daysSince = DateTime.now().difference(_latestRecord!.recordedAt).inDays;
    final weightDiff = 0.0; // Will be calculated when new weight is entered
    
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, size: 20),
                const SizedBox(width: 8),
                Text(
                  '前回の記録',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_latestRecord!.weight.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$daysSince日前',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (_latestRecord!.bodyFat != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '体脂肪率: ${_latestRecord!.bodyFat!.toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (_latestRecord!.muscleMass != null)
                        Text(
                          '筋肉量: ${_latestRecord!.muscleMass!.toStringAsFixed(1)}kg',
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('日付'),
            subtitle: Text(
              '${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}',
            ),
            onTap: () async {
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('時刻'),
            subtitle: Text(_selectedTime.format(context)),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '体重',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                suffixText: 'kg',
                hintText: '例: 65.5',
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
              onChanged: (value) {
                setState(() {}); // Update BMI display
              },
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_latestRecord != null && _weightController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildWeightDifference(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWeightDifference() {
    final currentWeight = double.tryParse(_weightController.text);
    if (currentWeight == null) return const SizedBox.shrink();
    
    final diff = currentWeight - _latestRecord!.weight;
    final color = diff > 0 ? Colors.red : diff < 0 ? Colors.green : Colors.grey;
    final icon = diff > 0 ? Icons.arrow_upward : diff < 0 ? Icons.arrow_downward : Icons.remove;
    
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyCompositionInputs() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '体組成（オプション）',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bodyFatController,
                    decoration: const InputDecoration(
                      labelText: '体脂肪率',
                      suffixText: '%',
                      hintText: '例: 20.5',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _muscleMassController,
                    decoration: const InputDecoration(
                      labelText: '筋肉量',
                      suffixText: 'kg',
                      hintText: '例: 50.0',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            labelText: 'メモ',
            hintText: '体調や食事の記録など',
            prefixIcon: Icon(Icons.note),
          ),
          maxLines: 3,
        ),
      ),
    );
  }

  Widget _buildBMIDisplay() {
    final weightText = _weightController.text;
    if (weightText.isEmpty) return const SizedBox.shrink();
    
    final weight = double.tryParse(weightText);
    if (weight == null) return const SizedBox.shrink();
    
    return FutureBuilder<UserProfile?>(
      future: _setupService.getUserProfile(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        
        final profile = snapshot.data!;
        final heightInMeters = profile.height / 100;
        final bmi = weight / (heightInMeters * heightInMeters);
        
        String category;
        Color color;
        if (bmi < 18.5) {
          category = '低体重';
          color = Colors.blue;
        } else if (bmi < 25) {
          category = '標準体重';
          color = Colors.green;
        } else if (bmi < 30) {
          category = '肥満度1';
          color = Colors.orange;
        } else {
          category = '肥満度2以上';
          color = Colors.red;
        }
        
        return Card(
          color: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'BMI',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bmi.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  '身長 ${profile.height}cm で計算',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveWeight() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSaving = true;
    });
    
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
      
      // Update user profile with new weight if it's the latest
      if (recordedAt.isAfter(_latestRecord?.recordedAt ?? DateTime(2000))) {
        final profile = await _setupService.getUserProfile();
        if (profile != null) {
          await _setupService.updateUserProfile(
            profile.copyWith(weight: record.weight),
          );
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('体重を記録しました'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear form
        _bodyFatController.clear();
        _muscleMassController.clear();
        _noteController.clear();
        
        // Reload latest record
        await _loadLatestRecord();
        
        // Switch to graph tab
        DefaultTabController.of(context).animateTo(1);
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
}

class _WeightGraphTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_WeightGraphTab> createState() => _WeightGraphTabState();
}

class _WeightGraphTabState extends ConsumerState<_WeightGraphTab> {
  final _recordStorageService = RecordStorageService();
  final _setupService = SetupService();
  
  List<WeightRecord> _records = [];
  bool _isLoading = true;
  int _selectedPeriod = 30; // days
  bool _showBodyFat = false;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: _selectedPeriod));
      
      final records = await _recordStorageService.getWeightRecordsByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      
      final profile = await _setupService.getUserProfile();
      
      setState(() {
        _records = records.reversed.toList(); // Oldest to newest for graph
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPeriodSelector(),
        _buildToggleButtons(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _records.isEmpty
                  ? _buildEmptyState()
                  : _buildGraph(),
        ),
        _buildStatistics(),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPeriodChip('1週間', 7),
          const SizedBox(width: 8),
          _buildPeriodChip('1ヶ月', 30),
          const SizedBox(width: 8),
          _buildPeriodChip('3ヶ月', 90),
          const SizedBox(width: 8),
          _buildPeriodChip('1年', 365),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, int days) {
    final isSelected = _selectedPeriod == days;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPeriod = days;
          });
          _loadData();
        }
      },
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            label: const Text('体脂肪率'),
            selected: _showBodyFat,
            onSelected: (selected) {
              setState(() {
                _showBodyFat = selected;
              });
            },
          ),
          const SizedBox(width: 8),
          if (_userProfile?.targetWeight != null)
            Chip(
              label: Text('目標: ${_userProfile!.targetWeight!.toStringAsFixed(1)}kg'),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'この期間の記録はありません',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraph() {
    final minWeight = _records.map((r) => r.weight).reduce((a, b) => a < b ? a : b) - 2;
    final maxWeight = _records.map((r) => r.weight).reduce((a, b) => a > b ? a : b) + 2;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[300]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= _records.length) return const Text('');
                  final date = _records[value.toInt()].recordedAt;
                  return Text(
                    '${date.month}/${date.day}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
                interval: _selectedPeriod <= 30 ? 7 : 30,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: _showBodyFat,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 10, color: Colors.orange),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // Weight line
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
            // Target weight line
            if (_userProfile?.targetWeight != null)
              LineChartBarData(
                spots: List.generate(_records.length, (index) {
                  return FlSpot(index.toDouble(), _userProfile!.targetWeight!);
                }),
                isCurved: false,
                color: Colors.red,
                barWidth: 2,
                dotData: FlDotData(show: false),
                dashArray: [5, 5],
              ),
            // Body fat line
            if (_showBodyFat)
              LineChartBarData(
                spots: _records.asMap().entries
                    .where((entry) => entry.value.bodyFat != null)
                    .map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.bodyFat!);
                }).toList(),
                isCurved: true,
                color: Colors.orange,
                barWidth: 2,
                dotData: FlDotData(show: false),
              ),
          ],
          minY: minWeight,
          maxY: maxWeight,
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    if (_records.isEmpty) return const SizedBox.shrink();
    
    final latestWeight = _records.last.weight;
    final oldestWeight = _records.first.weight;
    final weightChange = latestWeight - oldestWeight;
    final avgWeight = _records.map((r) => r.weight).reduce((a, b) => a + b) / _records.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '現在',
            '${latestWeight.toStringAsFixed(1)}kg',
            Theme.of(context).primaryColor,
          ),
          _buildStatItem(
            '変化',
            '${weightChange > 0 ? '+' : ''}${weightChange.toStringAsFixed(1)}kg',
            weightChange > 0 ? Colors.red : Colors.green,
          ),
          _buildStatItem(
            '平均',
            '${avgWeight.toStringAsFixed(1)}kg',
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}