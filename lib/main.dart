import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_localizations.dart';
import 'business/providers/locale_provider.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/camera_screen.dart';
import 'presentation/screens/result_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/setup_guide_screen.dart';
import 'presentation/screens/manual_meal_entry_screen.dart';
import 'presentation/screens/exercise_screen.dart';
import 'config/ai_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AI configuration with environment variables
  await AIConfig.initialize();
  
  runApp(
    const ProviderScope(
      child: CalorieCheckerApp(),
    ),
  );
}

class CalorieCheckerApp extends ConsumerWidget {
  const CalorieCheckerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Calorie Checker AI',
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF69B4), // ピンク
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.notoSansTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFF69B4),
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF69B4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFF69B4),
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainNavigationScreen(),
        '/setup': (context) => const SetupGuideScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/camera': (context) => const CameraScreen(),
        '/result': (context) => const ResultScreen(),
        '/manual-meal-entry': (context) => const ManualMealEntryScreen(),
        '/exercise': (context) => const ExerciseScreen(),
      },
    );
  }
}