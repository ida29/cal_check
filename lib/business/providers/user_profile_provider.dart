import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/setup_service.dart';

final setupServiceProvider = Provider<SetupService>((ref) {
  return SetupService();
});

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final setupService = ref.watch(setupServiceProvider);
  return await setupService.getUserProfile();
});

final userBMIProvider = FutureProvider<double?>((ref) async {
  final setupService = ref.watch(setupServiceProvider);
  return await setupService.calculateBMI();
});

final userBMRProvider = FutureProvider<double?>((ref) async {
  final setupService = ref.watch(setupServiceProvider);
  return await setupService.calculateBMR();
});

final userTDEEProvider = FutureProvider<double?>((ref) async {
  final setupService = ref.watch(setupServiceProvider);
  return await setupService.calculateTDEE();
});

final dailyCalorieGoalProvider = FutureProvider<double?>((ref) async {
  final setupService = ref.watch(setupServiceProvider);
  return await setupService.calculateDailyCalorieGoal();
});