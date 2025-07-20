import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/weight_record.dart';
import '../services/record_storage_service.dart';

final weightRecordServiceProvider = Provider<RecordStorageService>((ref) {
  return RecordStorageService();
});

final todayWeightRecordProvider = FutureProvider.autoDispose<bool>((ref) async {
  final service = ref.watch(weightRecordServiceProvider);
  final today = DateTime.now();
  final todayStart = DateTime(today.year, today.month, today.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  
  final records = await service.getWeightRecordsByDateRange(
    startDate: todayStart,
    endDate: todayEnd,
  );
  
  return records.isNotEmpty;
});

final latestWeightRecordProvider = FutureProvider.autoDispose<WeightRecord?>((ref) async {
  final service = ref.watch(weightRecordServiceProvider);
  return await service.getLatestWeightRecord();
});

final weightRecordsByDateRangeProvider = FutureProvider.autoDispose.family<List<WeightRecord>, DateRange>((ref, dateRange) async {
  final service = ref.watch(weightRecordServiceProvider);
  return await service.getWeightRecordsByDateRange(
    startDate: dateRange.startDate,
    endDate: dateRange.endDate,
  );
});

class DateRange {
  final DateTime startDate;
  final DateTime endDate;
  
  const DateRange({required this.startDate, required this.endDate});
}