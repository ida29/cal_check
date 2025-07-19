import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../l10n/app_localizations.dart';
import '../../data/entities/meal.dart';
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';
import '../../business/providers/meal_provider.dart';

class ManualMealEntryScreen extends ConsumerStatefulWidget {
  final Meal? meal;

  const ManualMealEntryScreen({Key? key, this.meal}) : super(key: key);

  @override
  ConsumerState<ManualMealEntryScreen> createState() => _ManualMealEntryScreenState();
}

class _ManualMealEntryScreenState extends ConsumerState<ManualMealEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  MealType _selectedMealType = MealType.breakfast;
  DateTime _selectedDateTime = DateTime.now();
  List<FoodItem> _foodItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      _initializeFromMeal(widget.meal!);
    }
  }

  void _initializeFromMeal(Meal meal) {
    _selectedMealType = meal.mealType;
    _selectedDateTime = meal.timestamp;
    _foodItems = List.from(meal.foodItems);
    _notesController.text = meal.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal'),
        actions: [
          if (widget.meal != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteMeal,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildMealTypeSelector(),
            const SizedBox(height: 16),
            _buildDateTimeSelector(),
            const SizedBox(height: 16),
            _buildFoodItemsSection(),
            const SizedBox(height: 16),
            _buildNotesField(),
            const SizedBox(height: 24),
            _buildSummaryCard(),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Type',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: MealType.values.map((type) {
                return ChoiceChip(
                  label: Text(_getMealTypeName(type)),
                  selected: _selectedMealType == type,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedMealType = type;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(_formatDate(_selectedDateTime)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(_formatTime(_selectedDateTime)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Food Items',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: _addFoodItem,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_foodItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text('No food items added yet'),
                ),
              )
            else
              ..._foodItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return _buildFoodItemTile(item, index);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodItemTile(FoodItem item, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('${item.quantity.toStringAsFixed(1)} ${item.unit}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${item.calories.toStringAsFixed(0)} cal',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _editFoodItem(index),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _removeFoodItem(index),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes (Optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any notes about this meal...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final totalCalories = _foodItems.fold<double>(0, (sum, item) => sum + item.calories);
    final totalNutrition = _calculateTotalNutrition();

    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Calories'),
                Text(
                  '${totalCalories.toStringAsFixed(0)} cal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Protein'),
                Text('${totalNutrition.protein.toStringAsFixed(1)}g'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Carbs'),
                Text('${totalNutrition.carbohydrates.toStringAsFixed(1)}g'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fat'),
                Text('${totalNutrition.fat.toStringAsFixed(1)}g'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveMeal,
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(widget.meal == null ? 'Save Meal' : 'Update Meal'),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _addFoodItem() {
    _showFoodItemDialog();
  }

  void _editFoodItem(int index) {
    _showFoodItemDialog(foodItem: _foodItems[index], index: index);
  }

  void _removeFoodItem(int index) {
    setState(() {
      _foodItems.removeAt(index);
    });
  }

  void _showFoodItemDialog({FoodItem? foodItem, int? index}) {
    showDialog(
      context: context,
      builder: (context) => _FoodItemDialog(
        foodItem: foodItem,
        onSave: (item) {
          setState(() {
            if (index != null) {
              _foodItems[index] = item;
            } else {
              _foodItems.add(item);
            }
          });
        },
      ),
    );
  }

  NutritionInfo _calculateTotalNutrition() {
    return _foodItems.fold(
      const NutritionInfo(
        calories: 0,
        protein: 0,
        carbohydrates: 0,
        fat: 0,
        fiber: 0,
        sugar: 0,
        sodium: 0,
      ),
      (total, item) => NutritionInfo(
        calories: total.calories + item.nutritionInfo.calories,
        protein: total.protein + item.nutritionInfo.protein,
        carbohydrates: total.carbohydrates + item.nutritionInfo.carbohydrates,
        fat: total.fat + item.nutritionInfo.fat,
        fiber: total.fiber + item.nutritionInfo.fiber,
        sugar: total.sugar + item.nutritionInfo.sugar,
        sodium: total.sodium + item.nutritionInfo.sodium,
      ),
    );
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate() || _foodItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one food item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final totalCalories = _foodItems.fold<double>(0, (sum, item) => sum + item.calories);
      final totalNutrition = _calculateTotalNutrition();

      final meal = Meal(
        id: widget.meal?.id ?? const Uuid().v4(),
        timestamp: _selectedDateTime,
        mealType: _selectedMealType,
        imagePath: widget.meal?.imagePath ?? '',
        foodItems: _foodItems,
        totalCalories: totalCalories,
        totalNutrition: totalNutrition,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isManualEntry: true,
      );

      if (widget.meal == null) {
        await ref.read(mealsProvider.notifier).saveMeal(meal);
      } else {
        await ref.read(mealsProvider.notifier).updateMeal(meal);
      }

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.meal == null ? 'Meal saved successfully' : 'Meal updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving meal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteMeal() async {
    if (widget.meal == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meal'),
        content: const Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(mealsProvider.notifier).deleteMeal(widget.meal!.id);
        if (mounted) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meal deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting meal: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getMealTypeName(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}

class _FoodItemDialog extends StatefulWidget {
  final FoodItem? foodItem;
  final Function(FoodItem) onSave;

  const _FoodItemDialog({Key? key, this.foodItem, required this.onSave}) : super(key: key);

  @override
  State<_FoodItemDialog> createState() => _FoodItemDialogState();
}

class _FoodItemDialogState extends State<_FoodItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.foodItem != null) {
      _initializeFromFoodItem(widget.foodItem!);
    } else {
      _unitController.text = 'g';
    }
  }

  void _initializeFromFoodItem(FoodItem item) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
    _unitController.text = item.unit;
    _caloriesController.text = item.calories.toString();
    _proteinController.text = item.nutritionInfo.protein.toString();
    _carbsController.text = item.nutritionInfo.carbohydrates.toString();
    _fatController.text = item.nutritionInfo.fat.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    widget.foodItem == null ? 'Add Food Item' : 'Edit Food Item',
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
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Food Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter food name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Required';
                              }
                              if (double.tryParse(value!) == null) {
                                return 'Invalid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _unitController,
                            decoration: const InputDecoration(
                              labelText: 'Unit *',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Calories *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter calories';
                        }
                        if (double.tryParse(value!) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nutrition (Optional)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Carbohydrates (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Fat (g)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFoodItem,
                      child: const Text('Save'),
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

  void _saveFoodItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final foodItem = FoodItem(
      id: widget.foodItem?.id ?? const Uuid().v4(),
      name: _nameController.text,
      quantity: double.parse(_quantityController.text),
      unit: _unitController.text,
      calories: double.parse(_caloriesController.text),
      nutritionInfo: NutritionInfo(
        calories: double.parse(_caloriesController.text),
        protein: double.tryParse(_proteinController.text) ?? 0,
        carbohydrates: double.tryParse(_carbsController.text) ?? 0,
        fat: double.tryParse(_fatController.text) ?? 0,
        fiber: 0,
        sugar: 0,
        sodium: 0,
      ),
    );

    widget.onSave(foodItem);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }
}