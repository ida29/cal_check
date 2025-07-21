import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/entities/weight_record.dart';
import '../../business/services/record_storage_service.dart';
import '../../business/services/setup_service.dart';
import '../../business/providers/weight_provider.dart';

class WeightRecordScreen extends ConsumerStatefulWidget {
  const WeightRecordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeightRecordScreen> createState() => _WeightRecordScreenState();
}

class _WeightRecordScreenState extends ConsumerState<WeightRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recordStorageService = RecordStorageService();
  final _setupService = SetupService();
  
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _weightController.dispose();
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
        bodyFat: null,
        muscleMass: null,
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
        // Refresh weight provider
        ref.refresh(todayWeightRecordProvider);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('体重を記録しました'),
            backgroundColor: Colors.green,
          ),
        );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('体重を記録'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date and time selector card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '記録日時',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, 
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime,
                                );
                                if (picked != null) {
                                  setState(() => _selectedTime = picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Weight input card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '体重',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _weightController,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: '0.0',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                            ),
                            suffixText: 'kg',
                            suffixStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
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
                            if (weight == null || weight <= 0 || weight > 500) {
                              return '正しい体重を入力してください';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Note input card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'メモ（任意）',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: '体調や気づいたことなど',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: const EdgeInsets.all(16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveWeight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          '記録する',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Cancel button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'キャンセル',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}