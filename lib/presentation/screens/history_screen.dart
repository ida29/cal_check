import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../../business/services/local_photo_storage_service.dart';
import '../../business/providers/meal_provider.dart';
import '../../business/providers/exercise_provider.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/exercise.dart';
import '../widgets/food_name_display.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  List<MealPhotoMetadata> _mealPhotos = [];
  List<Meal> _mealRecords = [];
  List<Exercise> _exerciseRecords = [];
  bool _isLoading = true;
  String _selectedPeriod = 'day'; // 'day', 'week', 'month'
  String _selectedTab = 'all'; // 'all', 'meals', 'exercises'
  
  final LocalPhotoStorageService _storageService = LocalPhotoStorageService();

  @override
  void initState() {
    super.initState();
    _loadMealData();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when coming back to this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProviders();
    });
  }
  
  void _refreshProviders() {
    // Force refresh the providers
    ref.read(mealsByDateProvider(_selectedDate).notifier).refreshMeals();
    ref.read(exercisesByDateProvider(_selectedDate).notifier).refreshExercises();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('食事管理'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedTab = index == 0 ? 'all' : (index == 1 ? 'meals' : 'exercises');
              });
            },
            tabs: [
              Tab(text: '全て'),
              Tab(text: '食事'),
              Tab(text: '運動'),
            ],
          ),
          actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
                _loadMealData();
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'day', child: Text(AppLocalizations.of(context)!.dayView)),
              PopupMenuItem(value: 'week', child: Text(AppLocalizations.of(context)!.weekView)),
              PopupMenuItem(value: 'month', child: Text(AppLocalizations.of(context)!.monthView)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
        body: SafeArea(
          child: Column(
          children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                      _loadMealData();
                      _refreshProviders();
                    });
                  },
                ),
                Text(
                  _formatDate(_selectedDate),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                      _loadMealData();
                      _refreshProviders();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.totalCalories,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${_getTotalCalories().toStringAsFixed(0)} cal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    ));
  }

  Future<void> _loadMealData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load meal photos
      List<MealPhotoMetadata> photos;
      
      switch (_selectedPeriod) {
        case 'day':
          photos = await _getMealPhotosForDay(_selectedDate);
          break;
        case 'week':
          photos = await _getMealPhotosForWeek(_selectedDate);
          break;
        case 'month':
          photos = await _getMealPhotosForMonth(_selectedDate);
          break;
        default:
          photos = await _getMealPhotosForDay(_selectedDate);
      }

      // Load meal records from database
      final mealsAsync = ref.read(mealsByDateProvider(_selectedDate));
      final mealsData = mealsAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <Meal>[],
      );
      
      // Load exercise records from database
      final exercisesAsync = ref.read(exercisesByDateProvider(_selectedDate));
      final exercisesData = exercisesAsync.maybeWhen(
        data: (data) => data,
        orElse: () => <Exercise>[],
      );

      setState(() {
        _mealPhotos = photos;
        _mealRecords = mealsData;
        _exerciseRecords = exercisesData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading meal data: $e');
      setState(() {
        _mealPhotos = [];
        _mealRecords = [];
        _exerciseRecords = [];
        _isLoading = false;
      });
    }
  }

  Future<List<MealPhotoMetadata>> _getMealPhotosForDay(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return await _storageService.getMealPhotosByDateRange(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  Future<List<MealPhotoMetadata>> _getMealPhotosForWeek(DateTime date) async {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return await _storageService.getMealPhotosByDateRange(
      startDate: DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      endDate: DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day),
    );
  }

  Future<List<MealPhotoMetadata>> _getMealPhotosForMonth(DateTime date) async {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 1);
    
    return await _storageService.getMealPhotosByDateRange(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  Widget _buildContent() {
    // Get fresh data from providers
    final mealsAsync = ref.watch(mealsByDateProvider(_selectedDate));
    final exercisesAsync = ref.watch(exercisesByDateProvider(_selectedDate));
    
    return mealsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('エラー: $error')),
      data: (meals) {
        return exercisesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('エラー: $error')),
          data: (exercises) {
            // Update local state with fresh data
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _mealRecords = meals;
                  _exerciseRecords = exercises;
                });
              }
            });
            
            if (_selectedTab == 'all') {
              return _buildAllRecords(meals, exercises);
            } else if (_selectedTab == 'meals') {
              return _buildMealsOnly(meals);
            } else {
              return _buildExercisesOnly(exercises);
            }
          },
        );
      },
    );
  }

  Widget _buildAllRecords(List<Meal> meals, List<Exercise> exercises) {
    final hasAnyData = _mealPhotos.isNotEmpty || meals.isNotEmpty || exercises.isNotEmpty;
    
    if (!hasAnyData) {
      return _buildEmptyState();
    }
    
    if (_selectedPeriod == 'day') {
      return _buildDayViewAll();
    } else {
      return _buildListViewAll();
    }
  }

  Widget _buildMealsOnly(List<Meal> meals) {
    final hasAnyData = _mealPhotos.isNotEmpty || meals.isNotEmpty;
    
    if (!hasAnyData) {
      return _buildEmptyState();
    }
    
    if (_selectedPeriod == 'day') {
      return _buildDayView();
    } else {
      return _buildListView();
    }
  }

  Widget _buildExercisesOnly(List<Exercise> exercises) {
    if (exercises.isEmpty) {
      return _buildEmptyStateExercise();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        return _buildExerciseCard(exercises[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.no_meals,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noMealsRecorded,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.startTakingPhotos,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateExercise() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '運動記録がありません',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '運動を記録してください',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealHistory() {
    if (_selectedPeriod == 'day') {
      return _buildDayView();
    } else {
      return _buildListView();
    }
  }

  Widget _buildDayView() {
    // Group all meals by type
    final mealsByType = <String, List<dynamic>>{};
    
    // Add photo meals
    for (final meal in _mealPhotos) {
      mealsByType.putIfAbsent(meal.mealType, () => []).add(meal);
    }
    
    // Add database meals
    for (final meal in _mealRecords) {
      final typeStr = meal.mealType.toString().split('.').last;
      mealsByType.putIfAbsent(typeStr, () => []).add(meal);
    }

    final mealOrder = ['breakfast', 'lunch', 'dinner', 'snack'];
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: mealOrder
          .where((type) => mealsByType.containsKey(type))
          .map((type) => _buildMealTypeSection(type, mealsByType[type]!))
          .toList(),
    );
  }

  Widget _buildDayViewAll() {
    // Combine all records with timestamps
    final allRecords = <_RecordItem>[];
    
    // Add photo meals
    for (final meal in _mealPhotos) {
      allRecords.add(_RecordItem(
        type: 'photo_meal',
        timestamp: meal.createdAt,
        data: meal,
      ));
    }
    
    // Add database meals
    for (final meal in _mealRecords) {
      allRecords.add(_RecordItem(
        type: 'db_meal',
        timestamp: meal.timestamp,
        data: meal,
      ));
    }
    
    // Add exercises
    for (final exercise in _exerciseRecords) {
      allRecords.add(_RecordItem(
        type: 'exercise',
        timestamp: exercise.timestamp,
        data: exercise,
      ));
    }
    
    // Sort by timestamp
    allRecords.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allRecords.length,
      itemBuilder: (context, index) {
        final record = allRecords[index];
        switch (record.type) {
          case 'photo_meal':
            return _buildMealCard(record.data as MealPhotoMetadata);
          case 'db_meal':
            return _buildMealRecordCard(record.data as Meal);
          case 'exercise':
            return _buildExerciseCard(record.data as Exercise);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildListView() {
    // Combine all meal records
    final allMeals = <_RecordItem>[];
    
    // Add photo meals
    for (final meal in _mealPhotos) {
      allMeals.add(_RecordItem(
        type: 'photo_meal',
        timestamp: meal.createdAt,
        data: meal,
      ));
    }
    
    // Add database meals
    for (final meal in _mealRecords) {
      allMeals.add(_RecordItem(
        type: 'db_meal',
        timestamp: meal.timestamp,
        data: meal,
      ));
    }
    
    // Sort by timestamp
    allMeals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allMeals.length,
      itemBuilder: (context, index) {
        final record = allMeals[index];
        if (record.type == 'photo_meal') {
          return _buildMealCard(record.data as MealPhotoMetadata);
        } else {
          return _buildMealRecordCard(record.data as Meal);
        }
      },
    );
  }

  Widget _buildListViewAll() {
    return _buildDayViewAll(); // Reuse the same logic
  }

  Widget _buildMealTypeSection(String mealType, List<dynamic> meals) {
    double totalCalories = 0;
    DateTime? firstMealTime;
    
    for (final meal in meals) {
      if (meal is MealPhotoMetadata) {
        totalCalories += meal.totalCalories;
        firstMealTime ??= meal.createdAt;
      } else if (meal is Meal) {
        totalCalories += meal.totalCalories;
        firstMealTime ??= meal.timestamp;
      }
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              _getMealIcon(mealType),
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(_getMealDisplayName(context, mealType)),
          subtitle: Text(_formatTime(firstMealTime ?? DateTime.now())),
          trailing: Text(
            '${totalCalories.toStringAsFixed(0)} cal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: meals.map<Widget>((meal) {
            if (meal is MealPhotoMetadata) {
              return _buildMealPhotoTile(meal);
            } else if (meal is Meal) {
              return _buildMealRecordTile(meal);
            }
            return const SizedBox.shrink();
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMealCard(MealPhotoMetadata meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildPhotoThumbnail(meal),
        title: Text(_getMealDisplayName(context, meal.mealType)),
        subtitle: Text(_formatDateTime(meal.createdAt)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${meal.totalCalories.toStringAsFixed(0)} cal',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${meal.foodItems.length} ${AppLocalizations.of(context)!.itemsCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () => _showMealDetails(meal),
      ),
    );
  }

  Widget _buildMealPhotoTile(MealPhotoMetadata meal) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      leading: _buildPhotoThumbnail(meal),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...meal.foodItems.map((item) => FoodNameDisplay(
            foodName: item.name,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
      trailing: Text(
        '${meal.totalCalories.toStringAsFixed(0)} cal',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      onTap: () => _showMealDetails(meal),
    );
  }

  Widget _buildPhotoThumbnail(MealPhotoMetadata meal) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(meal.savedPath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 50,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }

  double _getTotalCalories() {
    double photoCalories = _mealPhotos.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
    double mealCalories = _mealRecords.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
    double exerciseCalories = _exerciseRecords.fold<double>(0, (sum, exercise) => sum - exercise.caloriesBurned);
    
    if (_selectedTab == 'meals') {
      return photoCalories + mealCalories;
    } else if (_selectedTab == 'exercises') {
      return exerciseCalories;
    }
    return photoCalories + mealCalories + exerciseCalories;
  }


  void _showMealDetails(MealPhotoMetadata meal) {
    showDialog(
      context: context,
      builder: (context) => _MealDetailDialog(
        meal: meal,
        onMealDeleted: () {
          _loadMealData(); // Reload data after deletion
        },
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snack':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return AppLocalizations.of(context)!.today;
    } else if (dateToCheck == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadMealData();
        _refreshProviders();
      });
    }
  }

  Widget _buildMealRecordCard(Meal meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildMealRecordThumbnail(meal),
        title: Text(_getMealDisplayName(context, meal.mealType.toString().split('.').last)),
        subtitle: Text(_formatDateTime(meal.timestamp)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${meal.totalCalories.toStringAsFixed(0)} cal',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              '${meal.foodItems.length} ${AppLocalizations.of(context)!.itemsCount}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () => _showMealRecordDetails(meal),
      ),
    );
  }

  Widget _buildMealRecordTile(Meal meal) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      leading: _buildMealRecordThumbnail(meal),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...meal.foodItems.map((item) => FoodNameDisplay(
            foodName: item.name,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
      trailing: Text(
        '${meal.totalCalories.toStringAsFixed(0)} cal',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      onTap: () => _showMealRecordDetails(meal),
    );
  }

  Widget _buildMealRecordThumbnail(Meal meal) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: meal.imagePath.isNotEmpty && File(meal.imagePath).existsSync()
          ? Image.file(
              File(meal.imagePath),
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                );
              },
            )
          : Container(
              width: 50,
              height: 50,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant),
            ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: Icon(
            _getExerciseIcon(exercise.type),
            color: Colors.orange,
          ),
        ),
        title: Text(exercise.name),
        subtitle: Text(
          '${_formatDateTime(exercise.timestamp)} • ${exercise.durationMinutes}分',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '-${exercise.caloriesBurned.toStringAsFixed(0)} cal',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getExerciseIntensityText(exercise.intensity),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () => _showExerciseDetails(exercise),
      ),
    );
  }

  IconData _getExerciseIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.walking:
        return Icons.directions_walk;
      case ExerciseType.running:
        return Icons.directions_run;
      case ExerciseType.cycling:
        return Icons.directions_bike;
      case ExerciseType.swimming:
        return Icons.pool;
      case ExerciseType.cardio:
        return Icons.favorite;
      case ExerciseType.strength:
        return Icons.fitness_center;
      case ExerciseType.flexibility:
        return Icons.self_improvement;
      case ExerciseType.sports:
        return Icons.sports_basketball;
      case ExerciseType.other:
        return Icons.sports;
    }
  }

  String _getExerciseIntensityText(ExerciseIntensity intensity) {
    switch (intensity) {
      case ExerciseIntensity.low:
        return '低強度';
      case ExerciseIntensity.moderate:
        return '中強度';
      case ExerciseIntensity.high:
        return '高強度';
    }
  }

  void _showMealRecordDetails(Meal meal) {
    // TODO: Implement meal record details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('食事記録の詳細')),
    );
  }

  void _showExerciseDetails(Exercise exercise) {
    // TODO: Implement exercise details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('運動記録の詳細')),
    );
  }
}

class _MealDetailDialog extends StatelessWidget {
  final MealPhotoMetadata meal;
  final VoidCallback? onMealDeleted;

  const _MealDetailDialog({Key? key, required this.meal, this.onMealDeleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalNutrition = meal.totalNutrition;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with meal type and close button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getMealDisplayName(context, meal.mealType),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(meal.savedPath),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 48),
                                const Text('画像が見つかりません'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date and time
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          '${_formatDate(meal.createdAt)} ${_formatTime(meal.createdAt)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Total calories
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.totalCalories,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${meal.totalCalories.toStringAsFixed(0)} cal',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Nutrition breakdown
                    Text(
                      AppLocalizations.of(context)!.nutritionBreakdown,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildNutritionRow(
                              context,
                              AppLocalizations.of(context)!.protein,
                              '${totalNutrition.protein.toStringAsFixed(1)}g',
                              Colors.red,
                            ),
                            const Divider(),
                            _buildNutritionRow(
                              context,
                              AppLocalizations.of(context)!.carbs,
                              '${totalNutrition.carbohydrates.toStringAsFixed(1)}g',
                              Colors.orange,
                            ),
                            const Divider(),
                            _buildNutritionRow(
                              context,
                              AppLocalizations.of(context)!.fat,
                              '${totalNutrition.fat.toStringAsFixed(1)}g',
                              Colors.blue,
                            ),
                            if (totalNutrition.fiber > 0) ...[
                              const Divider(),
                              _buildNutritionRow(
                                context,
                                AppLocalizations.of(context)!.fiber,
                                '${totalNutrition.fiber.toStringAsFixed(1)}g',
                                Colors.green,
                              ),
                            ],
                            if (totalNutrition.sugar > 0) ...[
                              const Divider(),
                              _buildNutritionRow(
                                context,
                                AppLocalizations.of(context)!.sugar,
                                '${totalNutrition.sugar.toStringAsFixed(1)}g',
                                Colors.pink,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Food items
                    Text(
                      AppLocalizations.of(context)!.detectedItems,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ...meal.foodItems.map((item) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: FoodNameDisplay(
                          foodName: item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('${item.quantity.toStringAsFixed(0)} ${item.unit}'),
                        trailing: Text(
                          '${item.calories.toStringAsFixed(0)} cal',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deleteMeal(context, meal),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.close),
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

  Widget _buildNutritionRow(BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _getMealDisplayName(BuildContext context, String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return AppLocalizations.of(context)!.breakfast;
      case 'lunch':
        return AppLocalizations.of(context)!.lunch;
      case 'dinner':
        return AppLocalizations.of(context)!.dinner;
      case 'snack':
        return AppLocalizations.of(context)!.snack;
      default:
        return mealType;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  void _deleteMeal(BuildContext context, MealPhotoMetadata meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMeal),
        content: Text(AppLocalizations.of(context)!.deleteMealConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close confirmation dialog
              Navigator.of(context).pop(); // Close detail dialog
              
              final storageService = LocalPhotoStorageService();
              final success = await storageService.deleteMealPhoto(meal.id);
              
              if (success) {
                onMealDeleted?.call(); // Notify parent to reload data
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.mealDeletedSuccessfully),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.failedToDeleteMeal),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

}

class _RecordItem {
  final String type;
  final DateTime timestamp;
  final dynamic data;

  _RecordItem({
    required this.type,
    required this.timestamp,
    required this.data,
  });
}