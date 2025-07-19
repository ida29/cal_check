import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/manager_character_provider.dart';
import '../../business/models/manager_character.dart';
import '../../business/services/meal_reminder_service.dart';
import 'manager_character_setup_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> 
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _showCatMessage = false;

  @override
  void initState() {
    super.initState();
    // 食事リマインダータイマーを開始
    ref.read(mealReminderTimerProvider);
    
    // にゃんこのスライドアニメーション初期化
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    // 2秒後ににゃんこを表示
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final managerCharacter = ref.read(managerCharacterProvider);
        print('Manager character: ${managerCharacter?.type}'); // デバッグ用
        if (managerCharacter != null) { // テスト用：マネージャーが設定されていれば表示
          setState(() {
            _showCatMessage = true;
          });
          _slideController.forward();
          
          // 4秒後に自動的に隠す
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted && _showCatMessage) {
              _slideController.reverse().then((_) {
                if (mounted) {
                  setState(() {
                    _showCatMessage = false;
                  });
                }
              });
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotificationPanel();
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: FutureBuilder<int>(
                  future: _getUnreadNotificationCount(),
                  builder: (context, snapshot) {
                    final count = snapshot.data ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        count > 9 ? '9+' : count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // メインコンテンツ
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDailySummaryCard(),
                  const SizedBox(height: 8),
                  // スワイプヒント
                  Text(
                    '左右にスワイプして詳細を表示',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildMainActionButton(),
                  const SizedBox(height: 16),
                  _buildFoodRecordButton(),
                  const SizedBox(height: 16),
                  _buildExerciseRecordButton(),
                  const SizedBox(height: 20), // 下部に余白を追加
                ],
              ),
            ),
          ),
          // にゃんこメッセージオーバーレイ
          if (_showCatMessage) _buildCatMessageOverlay(),
        ],
      ),
    );
  }

  Widget _buildCatMessageOverlay() {
    final managerCharacter = ref.watch(managerCharacterProvider);
    if (managerCharacter == null) {
      return const SizedBox.shrink();
    }

    final messages = managerCharacter.type == CharacterType.cat 
        ? [
            'にゃーん！今日も食事記録頑張るにゃ〜！',
            'おつかれさまにゃ〜！水分補給も忘れずににゃ！',
            '運動もしてえらいにゃ〜！この調子にゃ！',
            'バランス良く食べてるにゃ〜！素晴らしいにゃ！',
          ]
        : [
            'こんにちは！今日も食事記録頑張りましょう！',
            'お疲れ様です！水分補給も忘れずに！',
            '運動もして素晴らしいですね！',
            'バランス良く食べていて素晴らしいです！',
          ];
    
    final randomMessage = messages[DateTime.now().millisecond % messages.length];

    return Positioned(
      top: 80,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 吹き出し
              Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.withOpacity(0.3), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.orange[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          managerCharacter.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: managerCharacter.type == CharacterType.cat 
                                ? Colors.orange[700]
                                : Colors.pink[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.55,
                      ),
                      child: Text(
                        randomMessage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // にゃんこキャラクター（シルエット）
              GestureDetector(
                onTap: () {
                  // タップで早めに消す
                  _slideController.reverse().then((_) {
                    if (mounted) {
                      setState(() {
                        _showCatMessage = false;
                      });
                    }
                  });
                },
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: managerCharacter.type == CharacterType.cat
                          ? [Colors.orange[300]!, Colors.orange[400]!]
                          : [Colors.pink[300]!, Colors.pink[400]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (managerCharacter.type == CharacterType.cat 
                            ? Colors.orange 
                            : Colors.pink).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    managerCharacter.type == CharacterType.cat 
                        ? Icons.pets 
                        : Icons.person,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailySummaryCard() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // ヘッダー部分
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _currentPage == 0 ? Icons.today_rounded : Icons.health_and_safety_rounded,
                        color: Colors.white,
                        size: 24
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentPage == 0 ? l10n.todayTotal : '健康指標',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // ページインジケーター
                  Row(
                    children: [
                      _buildPageIndicator(0),
                      const SizedBox(width: 4),
                      _buildPageIndicator(1),
                    ],
                  ),
                ],
              ),
            ),
            // スライド可能なコンテンツ
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildNutritionSummaryPage(l10n),
                  _buildHealthMetricsPage(l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageIndex) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == pageIndex 
            ? Colors.white 
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNutritionSummaryPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(l10n.calories, '1,245'),
                _buildSummaryItem(l10n.protein, '45g'),
                _buildSummaryItem(l10n.carbs, '180g'),
                _buildSummaryItem(l10n.fat, '40g'),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHealthMetricsPage(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // BMI & 水分摂取（横並び）
          Row(
            children: [
              Expanded(
                child: _buildCompactMetricCard(
                  Icons.monitor_weight,
                  'BMI',
                  '22.5',
                  '標準',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCompactMetricCard(
                  Icons.water_drop,
                  '水分',
                  '1.8L',
                  '/ 2.0L',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 運動時間 & 体重予測（横並び）
          Row(
            children: [
              Expanded(
                child: _buildCompactMetricCard(
                  Icons.fitness_center,
                  '運動',
                  '45分',
                  '240kcal',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCompactMetricCard(
                  Icons.trending_up,
                  '体重予測',
                  '-0.3kg',
                  '今月',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCompactMetricCard(IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildManagerCharacterSection() {
    final managerCharacter = ref.watch(managerCharacterProvider);
    
    if (managerCharacter == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ManagerCharacterSetupScreen(),
                settings: const RouteSettings(arguments: 'initial_setup'),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'マネージャーを設定しよう！',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '食事記録をサポートしてくれます',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: managerCharacter.type == CharacterType.human
                    ? Colors.pink[100]
                    : Colors.orange[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                managerCharacter.type == CharacterType.human
                    ? Icons.person
                    : Icons.pets,
                size: 35,
                color: managerCharacter.type == CharacterType.human
                    ? Colors.pink[300]
                    : Colors.orange[300],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    managerCharacter.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'マネージャー',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getEncouragementMessage(CharacterType type) {
    if (type == CharacterType.human) {
      return '順調に記録できていますね！その調子です！';
    } else {
      return 'よく頑張ってるにゃ〜！えらいにゃ〜！';
    }
  }

  Widget _buildMainActionButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB6C1), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/camera');
            },
            borderRadius: BorderRadius.circular(20),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '写真から記録',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'カメラで撮影して自動記録',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodRecordButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB347), Color(0xFFFF8C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/manual-meal-entry');
            },
            borderRadius: BorderRadius.circular(20),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '食べ物を選んで記録',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '食べ物を検索して手動で記録',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseRecordButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF98FB98), Color(0xFF32CD32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
            borderRadius: BorderRadius.circular(20),
            hoverColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '運動を記録',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '運動の種類と時間を記録',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future<int> _getUnreadNotificationCount() async {
    // TODO: 実際の未読通知数を取得する実装
    // 今は仮の値を返す
    final managerCharacter = ref.read(managerCharacterProvider);
    if (managerCharacter == null) return 0;
    
    final missedMeals = await MealReminderService.getMissedMealCount();
    return missedMeals;
  }

  void _showNotificationPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NotificationPanel(),
    );
  }
}

class NotificationPanel extends ConsumerWidget {
  const NotificationPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerCharacter = ref.watch(managerCharacterProvider);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
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
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '通知',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: すべて既読にする
                  },
                  child: const Text('すべて既読'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: _getNotifications(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final notifications = snapshot.data ?? [];
                
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '新しい通知はありません',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationTile(context, notification, managerCharacter);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationTile(BuildContext context, NotificationItem notification, ManagerCharacter? manager) {
    IconData icon;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.mealReminder:
        icon = Icons.restaurant;
        iconColor = Colors.orange;
        break;
      case NotificationType.achievement:
        icon = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
      case NotificationType.tip:
        icon = Icons.lightbulb_outline;
        iconColor = Colors.blue;
        break;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // TODO: 通知を既読にする
        },
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    } else {
      return '${difference.inDays}日前';
    }
  }
  
  Future<List<NotificationItem>> _getNotifications(WidgetRef ref) async {
    final notifications = <NotificationItem>[];
    final managerCharacter = ref.read(managerCharacterProvider);
    
    // 食事記録リマインダー
    final missedMeals = await MealReminderService.getMissedMealCount();
    if (missedMeals > 0) {
      final message = managerCharacter != null
          ? ManagerCharacterMessages.getRandomMessage(
              managerCharacter.type,
              managerCharacter.notificationLevel,
            )
          : '食事の記録を忘れていませんか？';
          
      notifications.add(NotificationItem(
        id: 'meal_reminder',
        type: NotificationType.mealReminder,
        title: '食事記録のリマインダー',
        message: message,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ));
    }
    
    // TODO: 他の通知を追加（実績、ヒントなど）
    
    return notifications;
  }
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  
  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
  });
}

enum NotificationType {
  mealReminder,
  achievement,
  tip,
}