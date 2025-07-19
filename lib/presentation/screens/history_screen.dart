import 'package:flutter/material.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';
import '../../business/services/local_photo_storage_service.dart';
import '../../data/entities/food_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  List<MealPhotoMetadata> _mealPhotos = [];
  bool _isLoading = true;
  String _selectedPeriod = 'day'; // 'day', 'week', 'month'
  
  final LocalPhotoStorageService _storageService = LocalPhotoStorageService();

  @override
  void initState() {
    super.initState();
    _loadMealData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.mealHistory),
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
              PopupMenuItem(value: 'day', child: Text('日別')),
              PopupMenuItem(value: 'week', child: Text('週別')),
              PopupMenuItem(value: 'month', child: Text('月別')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Column(
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
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _mealPhotos.isEmpty
                    ? _buildEmptyState()
                    : _buildMealHistory(),
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
    );
  }

  Future<void> _loadMealData() async {
    setState(() {
      _isLoading = true;
    });

    try {
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

      setState(() {
        _mealPhotos = photos;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading meal data: $e');
      setState(() {
        _mealPhotos = [];
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
            'No meals recorded',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start taking photos of your meals!',
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
    // Group photo meals by type
    final mealsByType = <String, List<MealPhotoMetadata>>{};
    
    // Add photo meals
    for (final meal in _mealPhotos) {
      mealsByType.putIfAbsent(meal.mealType, () => []).add(meal);
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

  Widget _buildListView() {
    // Sort photo meals by timestamp
    final sortedMeals = List<MealPhotoMetadata>.from(_mealPhotos);
    sortedMeals.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Most recent first
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMeals.length,
      itemBuilder: (context, index) {
        return _buildMealCard(sortedMeals[index]);
      },
    );
  }

  Widget _buildMealTypeSection(String mealType, List<MealPhotoMetadata> meals) {
    final totalCalories = meals.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
    
    final firstMeal = meals.first;
    final DateTime firstMealTime = firstMeal.createdAt;
    
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
          title: Text(_getMealDisplayName(mealType)),
          subtitle: Text(_formatTime(firstMealTime)),
          trailing: Text(
            '${totalCalories.toStringAsFixed(0)} cal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: meals.map((meal) => _buildMealPhotoTile(meal)).toList(),
        ),
      ),
    );
  }

  Widget _buildMealCard(MealPhotoMetadata meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: _buildPhotoThumbnail(meal),
        title: Text(_getMealDisplayName(meal.mealType)),
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
              '${meal.foodItems.length} items',
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
          ...meal.foodItems.map((item) => Text(
            item.name,
            style: Theme.of(context).textTheme.bodyMedium,
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
    return _mealPhotos.fold<double>(0, (sum, meal) => sum + meal.totalCalories);
  }

  String _getMealDisplayName(String mealType) {
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
      });
    }
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
                                Text('Image not found'),
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
                      'Nutrition Breakdown',
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
                                'Fiber',
                                '${totalNutrition.fiber.toStringAsFixed(1)}g',
                                Colors.green,
                              ),
                            ],
                            if (totalNutrition.sugar > 0) ...[
                              const Divider(),
                              _buildNutritionRow(
                                context,
                                'Sugar',
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
                        title: Text(item.name),
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
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
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

  void _deleteMeal(BuildContext context, MealPhotoMetadata meal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text('Are you sure you want to delete this meal? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
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
                  const SnackBar(
                    content: Text('Meal deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete meal'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}