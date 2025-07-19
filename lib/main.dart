import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/camera_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/history_screen.dart';
import 'presentation/screens/statistics_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: CalorieCheckerApp(),
    ),
  );
}

class CalorieCheckerApp extends StatelessWidget {
  const CalorieCheckerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Checker AI',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/camera': (context) => const CameraScreen(),
        '/result': (context) => const ResultScreen(),
        '/history': (context) => const HistoryScreen(),
        '/statistics': (context) => const StatisticsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}