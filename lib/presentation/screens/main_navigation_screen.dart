import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'home_screen.dart';
import 'history_screen.dart';
import 'weight_tracking_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
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
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFC1CC),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
}