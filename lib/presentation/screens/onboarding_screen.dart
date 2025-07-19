import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedGender = '';
  String _selectedActivityLevel = '';

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomePage(),
                  _buildPersonalInfoPage(),
                  _buildGoalsPage(),
                  _buildCompletePage(),
                ],
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            'Welcome to\nCalorie Checker AI',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Track your nutrition effortlessly with AI-powered food recognition. Just snap a photo and get instant calorie information!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 40),
          _buildFeatureList(),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem(Icons.camera_alt, 'Photo Recognition', 'Identify food from photos'),
        _buildFeatureItem(Icons.analytics, 'Smart Tracking', 'Automatic calorie calculation'),
        _buildFeatureItem(Icons.insights, 'Progress Insights', 'Track your nutrition goals'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Help us personalize your experience',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Text('Gender', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildGenderButton('Male'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton('Female'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderButton('Other'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Height (cm)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Text(
          gender,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity & Goals',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set your activity level and calorie goals',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          Text('Activity Level', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          ..._buildActivityLevelOptions(),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Recommended Daily Calories',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '2,000 cal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Based on your profile',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActivityLevelOptions() {
    final options = [
      {'title': 'Sedentary', 'subtitle': 'Little to no exercise'},
      {'title': 'Lightly Active', 'subtitle': 'Light exercise 1-3 days/week'},
      {'title': 'Moderately Active', 'subtitle': 'Moderate exercise 3-5 days/week'},
      {'title': 'Very Active', 'subtitle': 'Heavy exercise 6-7 days/week'},
      {'title': 'Extra Active', 'subtitle': 'Very heavy exercise, physical job'},
    ];

    return options.map((option) {
      final isSelected = _selectedActivityLevel == option['title'];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedActivityLevel = option['title']!;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[400],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                        ),
                      ),
                      Text(
                        option['subtitle']!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCompletePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 120,
            color: Colors.green,
          ),
          const SizedBox(height: 40),
          Text(
            'You\'re All Set!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            'Your profile has been created successfully. Start tracking your meals by taking photos of your food!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Back'),
            )
          else
            const SizedBox(width: 80),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
          if (_currentPage < 3)
            ElevatedButton(
              onPressed: _canProceed() ? () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } : null,
              child: const Text('Next'),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return true;
      case 1:
        return _nameController.text.isNotEmpty &&
               _ageController.text.isNotEmpty &&
               _heightController.text.isNotEmpty &&
               _weightController.text.isNotEmpty &&
               _selectedGender.isNotEmpty;
      case 2:
        return _selectedActivityLevel.isNotEmpty;
      default:
        return true;
    }
  }
}