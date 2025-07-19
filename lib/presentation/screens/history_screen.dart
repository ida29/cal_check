import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedDate = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
        actions: [
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMealSection('Breakfast', '08:30 AM', 420, [
                  {'name': 'Oatmeal with Berries', 'calories': 280},
                  {'name': 'Greek Yogurt', 'calories': 140},
                ]),
                _buildMealSection('Lunch', '12:45 PM', 650, [
                  {'name': 'Grilled Salmon', 'calories': 350},
                  {'name': 'Quinoa Salad', 'calories': 200},
                  {'name': 'Mixed Vegetables', 'calories': 100},
                ]),
                _buildMealSection('Snack', '03:30 PM', 180, [
                  {'name': 'Apple', 'calories': 95},
                  {'name': 'Almonds (15g)', 'calories': 85},
                ]),
                _buildMealSection('Dinner', '07:00 PM', 520, [
                  {'name': 'Chicken Stir Fry', 'calories': 380},
                  {'name': 'Brown Rice', 'calories': 140},
                ]),
              ],
            ),
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
                  'Total Calories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '1,770 cal',
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

  Widget _buildMealSection(String mealType, String time, int totalCalories, List<Map<String, dynamic>> items) {
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
          title: Text(mealType),
          subtitle: Text(time),
          trailing: Text(
            '$totalCalories cal',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: items.map((item) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            title: Text(item['name']),
            trailing: Text('${item['calories']} cal'),
          )).toList(),
        ),
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
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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