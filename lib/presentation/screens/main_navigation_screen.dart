import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/navigation_provider.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'weight_tracking_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'weight_record_screen.dart';
import 'camera_screen.dart';
import 'manual_meal_entry_screen.dart';
import 'exercise_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const WeightTrackingScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ルート引数からインデックスを取得（安全な型チェック）
    try {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null) {
        if (arguments is Map && arguments['initialIndex'] != null) {
          final index = arguments['initialIndex'];
          if (index is int && index >= 0 && index < _screens.length) {
            setState(() {
              _currentIndex = index;
            });
          }
        } else if (arguments is int && arguments >= 0 && arguments < _screens.length) {
          setState(() {
            _currentIndex = arguments;
          });
        }
      }
    } catch (e) {
      // エラーが発生した場合は無視（デフォルトのインデックスを使用）
      print('Error processing route arguments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navigationState = ref.watch(navigationProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (navigationState.subScreen != SubScreen.none)
            _buildSubScreen(navigationState.subScreen),
        ],
      ),
      bottomNavigationBar: navigationState.subScreen == SubScreen.camera
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFFFC1CC),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                ref.read(navigationProvider.notifier).setMainIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.history_outlined),
                  activeIcon: const Icon(Icons.history),
                  label: '食事管理',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.monitor_weight_outlined),
                  activeIcon: const Icon(Icons.monitor_weight),
                  label: '体重管理',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.insights_outlined),
                  activeIcon: const Icon(Icons.insights),
                  label: '体調管理',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings_outlined),
                  activeIcon: const Icon(Icons.settings),
                  label: l10n.settings,
                ),
              ],
            ),
    );
  }
  
  Widget _buildSubScreen(SubScreen subScreen) {
    final navigationState = ref.watch(navigationProvider);
    Widget? content;
    String title = '';
    
    switch (subScreen) {
      case SubScreen.weightRecord:
        content = const WeightRecordScreen();
        title = '体重を記録';
        break;
      case SubScreen.camera:
        content = const CameraScreen();
        title = '写真で記録';
        break;
      case SubScreen.manualMealEntry:
        content = const ManualMealEntryScreen();
        title = '食品を選んで記録';
        break;
      case SubScreen.exerciseEntry:
        content = const ExerciseScreen();
        title = '運動を記録';
        break;
      case SubScreen.none:
        return const SizedBox.shrink();
    }
    
    // カメラ画面の場合はフルスクリーン表示
    if (subScreen == SubScreen.camera) {
      return content ?? const SizedBox.shrink();
    }
    
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        ref.read(navigationProvider.notifier).clearSubScreen();
                      },
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: navigationState.onSubmit,
                      child: Text(
                        '登録する',
                        style: TextStyle(
                          color: navigationState.onSubmit != null 
                            ? const Color(0xFFFF69B4)
                            : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: content ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}