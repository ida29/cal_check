import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../business/services/setup_service.dart';

class SetupGuideScreen extends StatefulWidget {
  const SetupGuideScreen({Key? key}) : super(key: key);

  @override
  State<SetupGuideScreen> createState() => _SetupGuideScreenState();
}

class _SetupGuideScreenState extends State<SetupGuideScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  int _currentPage = 0;
  bool _isLoading = false;
  bool _showApiKey = false;
  String _selectedGender = '';
  String _selectedActivityLevel = '';
  String _selectedGoal = '';
  String _selectedTimeframe = '';
  
  final SetupService _setupService = SetupService();

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  for (int i = 0; i < 6; i++)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: i < 5 ? 8 : 0),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= _currentPage 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildBasicInfoPage(),
                  _buildPhysicalInfoPage(),
                  _buildGoalsPage(),
                  _buildApiSetupPage(),
                  _buildCompletePage(),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentPage > 0)
                    const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _nextPage,
                      child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_getNextButtonText()),
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

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to Calorie Checker!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'AI-powered calorie calculation from your meal photos',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  'Simply take a photo of your meal and get instant calorie information!',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This helps us provide better calorie recommendations',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Age input
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Enter your age',
                border: OutlineInputBorder(),
                suffixText: 'years',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                final age = int.tryParse(value);
                if (age == null || age < 10 || age > 120) {
                  return 'Please enter a valid age (10-120)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Gender selection
            Text(
              'Gender',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'male'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'male' 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _selectedGender == 'male' 
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.male,
                            size: 32,
                            color: _selectedGender == 'male' 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text('Male'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'female'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'female' 
                            ? Theme.of(context).primaryColor 
                            : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _selectedGender == 'female' 
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.female,
                            size: 32,
                            color: _selectedGender == 'female' 
                              ? Theme.of(context).primaryColor 
                              : Colors.grey[600],
                          ),
                          const SizedBox(height: 8),
                          Text('Female'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.monitor_weight,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Physical Information',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Help us calculate your daily calorie needs',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Height input
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Height',
                hintText: 'Enter your height',
                border: OutlineInputBorder(),
                suffixText: 'cm',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your height';
                }
                final height = double.tryParse(value);
                if (height == null || height < 100 || height > 250) {
                  return 'Please enter a valid height (100-250 cm)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Weight input
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Weight',
                hintText: 'Enter your weight',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                final weight = double.tryParse(value);
                if (weight == null || weight < 30 || weight > 300) {
                  return 'Please enter a valid weight (30-300 kg)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            
            // Activity level selection
            Text(
              'Activity Level',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildActivityOption('sedentary', 'Sedentary', 'Little to no exercise'),
                _buildActivityOption('light', 'Lightly Active', 'Light exercise 1-3 days/week'),
                _buildActivityOption('moderate', 'Moderately Active', 'Moderate exercise 3-5 days/week'),
                _buildActivityOption('very', 'Very Active', 'Hard exercise 6-7 days/week'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Your Goals',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Tell us about your weight goals',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Goal selection
            Text(
              'Your Goal',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildGoalOption('lose_weight', 'Lose Weight', Icons.trending_down),
                _buildGoalOption('maintain_weight', 'Maintain Weight', Icons.trending_flat),
                _buildGoalOption('gain_weight', 'Gain Weight', Icons.trending_up),
              ],
            ),
            const SizedBox(height: 24),
            
            // Target weight (only show if losing or gaining weight)
            if (_selectedGoal == 'lose_weight' || _selectedGoal == 'gain_weight') ...[
              TextFormField(
                controller: _targetWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Target Weight',
                  hintText: 'Enter your target weight',
                  border: const OutlineInputBorder(),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if ((_selectedGoal == 'lose_weight' || _selectedGoal == 'gain_weight') && 
                      (value == null || value.isEmpty)) {
                    return 'Please enter your target weight';
                  }
                  if (value != null && value.isNotEmpty) {
                    final target = double.tryParse(value);
                    if (target == null || target < 30 || target > 300) {
                      return 'Please enter a valid target weight (30-300 kg)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Timeframe selection
              Text(
                'Timeframe',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildTimeframeOption('3_months', '3 Months', 'Gradual and sustainable'),
                  _buildTimeframeOption('6_months', '6 Months', 'Balanced approach'),
                  _buildTimeframeOption('1_year', '1 Year', 'Long-term transformation'),
                  _buildTimeframeOption('custom', 'Custom', 'Set your own timeline'),
                ],
              ),
            ],
            
            if (_selectedGoal == 'maintain_weight') ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.balance,
                      color: Colors.green[700],
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Great Choice!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll help you maintain your current weight with balanced nutrition tracking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption(String value, String title, IconData icon) {
    final isSelected = _selectedGoal == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityOption(String value, String title, String description) {
    final isSelected = _selectedActivityLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivityLevel = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApiSetupPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.key,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'API Setup',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'To use AI analysis, you need an OpenRouter API key',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'How to get your API key:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('1. Visit https://openrouter.ai'),
                  const SizedBox(height: 4),
                  Text('2. Sign up for a free account'),
                  const SizedBox(height: 4),
                  Text('3. Go to Keys section'),
                  const SizedBox(height: 4),
                  Text('4. Create a new API key'),
                  const SizedBox(height: 4),
                  Text('5. Copy and paste it below'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // API Key input
            TextFormField(
              controller: _apiKeyController,
              obscureText: !_showApiKey,
              decoration: InputDecoration(
                labelText: 'OpenRouter API Key',
                hintText: 'sk-or-v1-...',
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(_showApiKey ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _showApiKey = !_showApiKey;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.paste),
                      onPressed: _pasteFromClipboard,
                    ),
                  ],
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your API key';
                }
                if (!value.startsWith('sk-or-v1-')) {
                  return 'Invalid API key format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Skip option
            TextButton(
              onPressed: _skipApiSetup,
              child: const Text('Skip for now (use demo mode)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Setup Complete!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re all set to start tracking your meals',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: Theme.of(context).primaryColor,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'Tips for Best Results',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('• Take photos in good lighting'),
                const Text('• Include the whole meal in frame'),
                const Text('• Avoid blurry or dark photos'),
                const Text('• Place food on contrasting backgrounds'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText() {
    switch (_currentPage) {
      case 0:
        return 'Get Started';
      case 1:
        return 'Continue';
      case 2:
        return 'Continue';
      case 3:
        return 'Continue';
      case 4:
        return 'Save & Continue';
      case 5:
        return 'Start Using App';
      default:
        return 'Next';
    }
  }

  void _nextPage() async {
    if (_currentPage == 1) {
      // Basic info page - validate
      if (_ageController.text.isEmpty || _selectedGender.isEmpty || _selectedGoal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all basic information')),
        );
        return;
      }
    } else if (_currentPage == 2) {
      // Physical info page - validate
      if (_heightController.text.isEmpty || _weightController.text.isEmpty || _selectedActivityLevel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all physical information')),
        );
        return;
      }
    } else if (_currentPage == 3) {
      // Goals page - validate
      if (_selectedGoal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your goal')),
        );
        return;
      }
      if ((_selectedGoal == 'lose_weight' || _selectedGoal == 'gain_weight')) {
        if (_targetWeightController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your target weight')),
          );
          return;
        }
        if (_selectedTimeframe.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a timeframe')),
          );
          return;
        }
      }
    } else if (_currentPage == 4) {
      // API setup page - validate and save
      if (_formKey.currentState?.validate() ?? false) {
        setState(() => _isLoading = true);
        
        try {
          // Save all user data
          await _setupService.saveUserProfile(
            age: int.parse(_ageController.text),
            gender: _selectedGender,
            height: double.parse(_heightController.text),
            weight: double.parse(_weightController.text),
            targetWeight: _targetWeightController.text.isNotEmpty 
              ? double.parse(_targetWeightController.text) 
              : null,
            activityLevel: _selectedActivityLevel,
            goal: _selectedGoal,
            timeframe: _selectedTimeframe.isNotEmpty ? _selectedTimeframe : null,
          );
          
          await _setupService.saveApiKey(_apiKeyController.text.trim());
          await _setupService.markSetupComplete();
          
          setState(() => _isLoading = false);
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving data: $e')),
          );
        }
      }
    } else if (_currentPage == 5) {
      // Complete setup and navigate to main app
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      // Regular navigation
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _apiKeyController.text = data!.text!;
    }
  }

  void _skipApiSetup() async {
    setState(() => _isLoading = true);
    
    try {
      // Save user profile data even if API key is skipped
      await _setupService.saveUserProfile(
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        targetWeight: _targetWeightController.text.isNotEmpty 
          ? double.parse(_targetWeightController.text) 
          : null,
        activityLevel: _selectedActivityLevel,
        goal: _selectedGoal,
        timeframe: _selectedTimeframe.isNotEmpty ? _selectedTimeframe : null,
      );
      
      await _setupService.markSetupComplete();
      setState(() => _isLoading = false);
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Widget _buildTimeframeOption(String value, String title, String description) {
    final isSelected = _selectedTimeframe == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeframe = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}