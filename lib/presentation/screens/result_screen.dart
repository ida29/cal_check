import 'package:flutter/material.dart';
import 'dart:io';
import '../../l10n/app_localizations.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String imagePath;
  bool _isAnalyzing = true;
  List<Map<String, dynamic>> _detectedItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    imagePath = args?['imagePath'] ?? '';
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _detectedItems = [
        {
          'name': 'Grilled Chicken Breast',
          'quantity': 150,
          'unit': 'g',
          'calories': 248,
          'confidence': 0.92,
        },
        {
          'name': 'Steamed Broccoli',
          'quantity': 100,
          'unit': 'g',
          'calories': 35,
          'confidence': 0.88,
        },
        {
          'name': 'Brown Rice',
          'quantity': 180,
          'unit': 'g',
          'calories': 216,
          'confidence': 0.85,
        },
      ];
      _isAnalyzing = false;
    });
  }

  double get _totalCalories {
    return _detectedItems.fold(0, (sum, item) => sum + (item['calories'] as num));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.analysisResults),
        actions: [
          TextButton(
            onPressed: _isAnalyzing ? null : _saveMeal,
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              color: Colors.black,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
            if (_isAnalyzing)
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(AppLocalizations.of(context)!.analyzingMeal),
                    ],
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.totalCalories,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_totalCalories.toStringAsFixed(0)} cal',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.detectedItems,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ..._detectedItems.map((item) => _buildFoodItemCard(item)),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _addCustomItem,
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.addItem),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
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

  Widget _buildFoodItemCard(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item['name'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(
                    '${(item['confidence'] * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getConfidenceColor(item['confidence']),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item['quantity']} ${item['unit']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${item['calories']} cal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _editItem(item),
                  child: Text(AppLocalizations.of(context)!.edit),
                ),
                TextButton(
                  onPressed: () => _removeItem(item),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text(AppLocalizations.of(context)!.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green.withOpacity(0.2);
    if (confidence >= 0.6) return Colors.orange.withOpacity(0.2);
    return Colors.red.withOpacity(0.2);
  }

  void _editItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.editComingSoon)),
    );
  }

  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      _detectedItems.remove(item);
    });
  }

  void _addCustomItem() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.addCustomItemComingSoon)),
    );
  }

  void _saveMeal() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.mealSavedSuccessfully)),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}