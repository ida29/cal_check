import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../business/providers/meal_provider.dart';
import '../../business/providers/weight_provider.dart';
import '../../business/providers/navigation_provider.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/nutrition_info.dart';

class TodoListScreen extends ConsumerStatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends ConsumerState<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('やること一覧'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _buildTodoListSync(hour, breakfastRecorded, lunchRecorded, dinnerRecorded, weightRecorded),
      ),
    );
  }

  Widget _buildTodoListSync(
    int hour,
    bool breakfastRecorded,
    bool lunchRecorded,
    bool dinnerRecorded,
    bool weightRecorded,
  ) {
    final todos = <TodoItem>[];
    
    // 体重記録
    if (!weightRecorded) {
      todos.add(TodoItem(
        title: '体重を記録',
        subtitle: '朝の体重を記録しましょう',
        icon: Icons.monitor_weight,
        color: Colors.teal,
        onTap: () => ref.read(navigationProvider.notifier).setSubScreen(SubScreen.weightRecord),
      ));
    }
    
    // 朝食
    if (hour >= 7 && !breakfastRecorded) {
      todos.add(TodoItem(
        title: '朝食を記録する',
        subtitle: '7:00〜10:00',
        icon: Icons.wb_sunny,
        color: Colors.orange,
        onTap: () => _showMealRecordOptions(),
      ));
    }
    
    // 昼食
    if (hour >= 12 && !lunchRecorded) {
      todos.add(TodoItem(
        title: '昼食を記録する',
        subtitle: '12:00〜14:00',
        icon: Icons.wb_sunny_outlined,
        color: Colors.yellow[700]!,
        onTap: () => _showMealRecordOptions(),
      ));
    }
    
    // 夕食
    if (hour >= 18 && !dinnerRecorded) {
      todos.add(TodoItem(
        title: '夕食を記録する',
        subtitle: '18:00〜20:00',
        icon: Icons.nights_stay,
        color: Colors.indigo,
        onTap: () => _showMealRecordOptions(),
      ));
    }
    
    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.green[400],
            ),
            const SizedBox(height: 16),
            Text(
              '今日のタスクは完了しました！',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'お疲れさまでした',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: todo.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: todo.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      todo.icon,
                      color: todo.color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (todo.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            todo.subtitle!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
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
        );
      },
    );
  }
  
  void _showMealRecordOptions() {
    // HomeScreenの_showMealRecordOptionsと同じ処理
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
                    Navigator.pop(context); // ボトムシートを閉じる
                    Navigator.pop(context); // やること一覧を閉じる
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
                    Navigator.pop(context); // ボトムシートを閉じる
                    Navigator.pop(context); // やること一覧を閉じる
                    ref.read(navigationProvider.notifier).setSubScreen(SubScreen.manualMealEntry);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.green.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.search_rounded,
                            color: Colors.green[700],
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '食品を選んで記録',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
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
                    Navigator.pop(context); // ボトムシートを閉じる
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
                    await _saveSkippedMeal(selectedMealType);
                    if (mounted) {
                      Navigator.of(context).pop(); // ダイアログを閉じる
                      Navigator.of(context).pop(); // やること一覧を閉じる
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
  
  Future<void> _saveSkippedMeal(MealType mealType) async {
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
    // Refresh the meals for today to update the state
    ref.refresh(mealsByDateProvider(DateTime.now()));
    // Also refresh the general meals provider to ensure home screen updates
    ref.refresh(mealsProvider);
  }
}

class TodoItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  TodoItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}