import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../business/providers/manager_character_provider.dart';
import '../../business/services/meal_reminder_service.dart';
import '../../business/providers/meal_provider.dart';
import '../../business/providers/weight_provider.dart';
import '../../business/providers/navigation_provider.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/nutrition_info.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> 
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _showCatMessage = false;
  String _currentCatMessage = '';

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
    Future.delayed(const Duration(seconds: 2), () async {
      if (mounted) {
        // タスク状況を確認してメッセージを選択
        final today = DateTime.now();
        final hour = DateTime.now().hour;
        
        // 食事記録の取得
        final mealsAsync = ref.read(mealsByDateProvider(today));
        final meals = mealsAsync.maybeWhen(
          data: (data) => data,
          orElse: () => <Meal>[],
        );
        
        // 食事タイプごとの記録状況をチェック
        final breakfastRecorded = meals.any((meal) => meal.mealType == MealType.breakfast);
        final lunchRecorded = meals.any((meal) => meal.mealType == MealType.lunch);
        final dinnerRecorded = meals.any((meal) => meal.mealType == MealType.dinner);
        
        // 体重記録の取得
        final weightRecordedAsync = ref.read(todayWeightRecordProvider);
        final weightRecorded = weightRecordedAsync.maybeWhen(
          data: (hasRecord) => hasRecord,
          orElse: () => false,
        );
        
        // タスクに応じたメッセージを生成
        final taskMessages = <String>[];
        final generalMessages = [
          'にゃーん！今日も食事記録頑張るにゃ〜！',
          'おつかれさまにゃ〜！水分補給も忘れずににゃ！',
          '運動もしてえらいにゃ〜！この調子にゃ！',
          'バランス良く食べてるにゃ〜！素晴らしいにゃ！',
        ];
        
        // 体重記録がない場合
        if (!weightRecorded) {
          taskMessages.addAll([
            'にゃーん！今日の体重まだ記録してないにゃ〜！',
            '体重記録忘れてるにゃ？毎日の記録が大切にゃ〜！',
            '朝の体重測定はもう済んだかにゃ〜？',
          ]);
        }
        
        // 設定でスキップされた食事を確認
        final prefs = await SharedPreferences.getInstance();
        final skipBreakfast = prefs.getBool('skipBreakfast') ?? false;
        final skipLunch = prefs.getBool('skipLunch') ?? false;
        final skipDinner = prefs.getBool('skipDinner') ?? false;
        
        // 時間帯に応じた食事記録リマインダー
        if (hour >= 7 && hour < 10 && !breakfastRecorded && !skipBreakfast) {
          taskMessages.addAll([
            'おはようにゃ〜！朝ごはん食べたら記録するにゃ！',
            '朝食の記録、忘れずににゃ〜！',
            'にゃーん！朝ごはんの写真撮るの忘れないでにゃ！',
          ]);
        } else if (hour >= 12 && hour < 14 && !lunchRecorded && !skipLunch) {
          taskMessages.addAll([
            'お昼ごはんの時間にゃ！記録も忘れずににゃ〜！',
            'ランチの記録まだにゃ？美味しそうなの食べてるにゃ〜？',
            'にゃーん！昼食の記録してないにゃ〜！',
          ]);
        } else if (hour >= 18 && hour < 21 && !dinnerRecorded && !skipDinner) {
          taskMessages.addAll([
            '夕ごはんの記録も忘れないでにゃ〜！',
            'ディナータイムにゃ！今日は何食べるにゃ〜？',
            'にゃーん！夕食の記録まだみたいにゃ〜！',
          ]);
        }
        
        // メッセージリストを結合
        final allMessages = taskMessages.isNotEmpty ? taskMessages : generalMessages;
        final randomIndex = DateTime.now().millisecondsSinceEpoch % allMessages.length;
        
        if (mounted) {
          setState(() {
            _currentCatMessage = allMessages[randomIndex];
            _showCatMessage = true;
          });
          _slideController.forward();
        }
        
        // 8秒後に自動的に隠す
        Future.delayed(const Duration(seconds: 8), () {
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
    });
  }

  @override
  void dispose() {
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
                  _buildTasksCard(),
                  const SizedBox(height: 20),
                  _buildMealRecordButton(),
                  const SizedBox(height: 16),
                  _buildWeightRecordButton(),
                  const SizedBox(height: 16),
                  _buildExerciseRecordButton(),
                  const SizedBox(height: 120), // にゃんこ表示用の余白
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

    return Positioned(
      bottom: 80, // フッターのギリギリ上に配置
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // にゃんこキャラクター（上に配置）
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
                child: Image.asset(
                  'assets/images/cat.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.pets,
                      size: 80,
                      color: Colors.orange[300],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              // メッセージコンテナ（下に配置）
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _currentCatMessage,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.brown[800],
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Hiragino Sans',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksCard() {
    final today = DateTime.now();
    final hour = DateTime.now().hour;
    
    // 食事記録の取得
    final mealsAsync = ref.watch(mealsByDateProvider(today));
    final meals = mealsAsync.maybeWhen(
      data: (data) => data,
      orElse: () => <Meal>[],
    );
    
    // 食事タイプごとの記録状況をチェック
    final breakfastRecorded = meals.any((meal) => meal.mealType == MealType.breakfast);
    final lunchRecorded = meals.any((meal) => meal.mealType == MealType.lunch);
    final dinnerRecorded = meals.any((meal) => meal.mealType == MealType.dinner);
    
    // 体重記録の取得
    final weightRecordedAsync = ref.watch(todayWeightRecordProvider);
    final weightRecorded = weightRecordedAsync.maybeWhen(
      data: (hasRecord) => hasRecord,
      orElse: () => false,
    );
    
    // タスクを表示するかどうかの判定
    return _buildTasksCardSync(hour, breakfastRecorded, lunchRecorded, dinnerRecorded, weightRecorded);
  }

  Widget _buildTasksCardSync(int hour, bool breakfastRecorded, bool lunchRecorded, bool dinnerRecorded, bool weightRecorded) {
    // タスク数を計算（間食は除外）
    int pendingTasks = 0;
    
    if (hour >= 7 && !breakfastRecorded) pendingTasks++;
    if (hour >= 12 && !lunchRecorded) pendingTasks++;
    if (hour >= 18 && !dinnerRecorded) pendingTasks++;
    if (!weightRecorded) pendingTasks++;

    // 優先度の高いタスクを決定
    String primaryTaskTitle = '';
    IconData primaryTaskIcon = Icons.task_alt;
    Color primaryTaskColor = Colors.orange;
    VoidCallback? primaryTaskAction;
    
    // 体重記録を最優先
    if (!weightRecorded) {
      primaryTaskTitle = '体重を記録';
      primaryTaskIcon = Icons.monitor_weight;
      primaryTaskColor = Colors.teal;
      primaryTaskAction = () => ref.read(navigationProvider.notifier).setSubScreen(SubScreen.weightRecord);
    } else if (hour >= 7 && !breakfastRecorded) {
      primaryTaskTitle = '朝食を記録する';
      primaryTaskIcon = Icons.wb_sunny;
      primaryTaskColor = Colors.orange;
      primaryTaskAction = () => _showMealRecordOptions();
    } else if (hour >= 12 && !lunchRecorded) {
      primaryTaskTitle = '昼食を記録する';
      primaryTaskIcon = Icons.wb_sunny_outlined;
      primaryTaskColor = Colors.yellow[700]!;
      primaryTaskAction = () => _showMealRecordOptions();
    } else if (hour >= 18 && !dinnerRecorded) {
      primaryTaskTitle = '夕食を記録する';
      primaryTaskIcon = Icons.nights_stay;
      primaryTaskColor = Colors.indigo;
      primaryTaskAction = () => _showMealRecordOptions();
    }
    
    // タスクがない場合は表示しない
    if (pendingTasks == 0) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [primaryTaskColor.withOpacity(0.8), primaryTaskColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: primaryTaskAction,
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
                    child: Icon(
                      primaryTaskIcon,
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
                          primaryTaskTitle,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pendingTasks > 1 
                            ? '他${pendingTasks - 1}件のタスク'
                            : 'タップして記録',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.task_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$pendingTasks',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
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



  Widget _buildMealRecordButton() {
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
              _showMealRecordOptions();
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
                          '食事を記録',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '写真や選択で食事を記録',
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

  Widget _buildWeightRecordButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)], // 青色のグラデーション
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/weight-record');
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
                      Icons.monitor_weight_rounded,
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
                          '体重を記録',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '今日の体重を記録',
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
              ref.read(navigationProvider.notifier).setSubScreen(SubScreen.exerciseEntry);
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

  void _showMealRecordOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  child: Text(
                    '記録方法を選択',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 写真で記録
                InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(navigationProvider.notifier).setSubScreen(SubScreen.camera);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB6C1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFB6C1).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Color(0xFFFF69B4),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '写真で記録',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF69B4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'AIが自動でカロリーを計算',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              // 食べ物を選んで記録
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  ref.read(navigationProvider.notifier).setSubScreen(SubScreen.manualMealEntry);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB347).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFFB347).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB347).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFFFF8C00),
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
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF8C00),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '食品データベースから検索',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              // 食べていない
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _showSkipMealDialog();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.no_meals_rounded,
                          color: Colors.orange,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '食べていない',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '食事を取らなかった場合',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // キャンセルボタン
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'キャンセル',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
          ),
        ),
      ),
    );
  }

  void _showSkipMealDialog() {
    final now = DateTime.now();
    final hour = now.hour;
    MealType defaultMealType;
    
    if (hour < 10) {
      defaultMealType = MealType.breakfast;
    } else if (hour < 14) {
      defaultMealType = MealType.lunch;
    } else if (hour < 20) {
      defaultMealType = MealType.dinner;
    } else {
      defaultMealType = MealType.snack;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        MealType selectedMealType = defaultMealType;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('食べていない'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('どの食事を食べていませんか？'),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MealType>(
                    value: selectedMealType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: MealType.values.map((type) {
                      String displayName;
                      switch (type) {
                        case MealType.breakfast:
                          displayName = '朝食';
                          break;
                        case MealType.lunch:
                          displayName = '昼食';
                          break;
                        case MealType.dinner:
                          displayName = '夕食';
                          break;
                        case MealType.snack:
                          displayName = '間食';
                          break;
                      }
                      return DropdownMenuItem(
                        value: type,
                        child: Text(displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMealType = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _saveSkippedMeal(selectedMealType, '');
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('記録しました'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text('記録'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveSkippedMeal(MealType mealType, String reason) async {
    // Save skipped meal as a meal with 0 calories
    final skippedMeal = Meal(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      mealType: mealType,
      imagePath: '',
      foodItems: [],
      totalCalories: 0,
      totalNutrition: const NutritionInfo(
        protein: 0,
        carbohydrates: 0,
        fat: 0,
        fiber: 0,
        sugar: 0,
        sodium: 0,
      ),
      notes: '食べていない',
      isSynced: false,
      isManualEntry: true,
    );
    
    await ref.read(mealsProvider.notifier).saveMeal(skippedMeal);
    // Refresh the meals for today
    ref.refresh(mealsByDateProvider(DateTime.now()));
    // Force rebuild of the home screen to update tasks immediately
    setState(() {});
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
  
  Widget _buildNotificationTile(BuildContext context, NotificationItem notification, dynamic manager) {
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
      // にゃんこのメッセージをランダムに選択
      final catMessages = [
        'にゃーん！食事の記録を忘れてるにゃ〜！',
        'お腹すいたにゃ？記録も忘れずににゃ〜！',
        'ごはんの時間にゃ！記録もお願いにゃ〜！',
        '食事記録してないにゃ〜？早めに記録にゃ！',
      ];
      final message = catMessages[DateTime.now().millisecond % catMessages.length];
          
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