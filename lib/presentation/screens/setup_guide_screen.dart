import 'package:flutter/material.dart';
import '../../business/services/setup_service.dart';

class SetupGuideScreen extends StatefulWidget {
  const SetupGuideScreen({Key? key}) : super(key: key);

  @override
  State<SetupGuideScreen> createState() => _SetupGuideScreenState();
}

class _SetupGuideScreenState extends State<SetupGuideScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  
  int _currentPage = 0;
  int _totalPages = 10; // Total number of questions
  bool _isLoading = false;
  String _selectedGender = '';
  String _selectedActivityLevel = '';
  String _selectedGoal = '';
  String _selectedTimeframe = '';
  
  final SetupService _setupService = SetupService();

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeInOut,
    ));
    _updateProgress();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  int _getEffectiveTotalPages() {
    if (_selectedGoal == 'maintain_weight') {
      return _totalPages - 2; // Skip target weight and timeframe pages
    }
    return _totalPages;
  }
  
  int _getEffectiveCurrentPage() {
    if (_selectedGoal == 'maintain_weight' && _currentPage >= 6) {
      if (_currentPage == 8) {
        return 6; // Activity level becomes page 6
      } else if (_currentPage == 9) {
        return 7; // Complete becomes page 7
      }
    }
    return _currentPage;
  }
  
  void _updateProgress() {
    final progress = (_getEffectiveCurrentPage() + 1) / _getEffectiveTotalPages();
    _progressAnimationController.animateTo(progress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced header with back button, progress, and close button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  // Top row with back button, question number, and close button
                  Row(
                    children: [
                      // Back button (left arrow icon)
                      if (_currentPage > 0)
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: IconButton(
                            onPressed: _previousPage,
                            icon: const Icon(Icons.arrow_back_ios),
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 44, height: 44),
                      
                      // Centered question number
                      Expanded(
                        child: Text(
                          'Question ${_getEffectiveCurrentPage() + 1} of ${_getEffectiveTotalPages()}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Close button (X icon)
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Progress percentage
                  Text(
                    '${((_getEffectiveCurrentPage() + 1) / _getEffectiveTotalPages() * 100).round()}% Complete',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // More prominent progress bar (8px height)
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Container(
                        width: double.infinity,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).primaryColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Page content with swipe physics
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _updateProgress();
                  });
                },
                children: [
                  _buildWelcomePage(),          // 0: Welcome
                  _buildAgePage(),              // 1: Age
                  _buildGenderPage(),           // 2: Gender  
                  _buildHeightPage(),           // 3: Height
                  _buildCurrentWeightPage(),    // 4: Current Weight
                  _buildGoalTypePage(),         // 5: Goal Type
                  _buildTargetWeightPage(),     // 6: Target Weight (conditional)
                  _buildTimeframePage(),        // 7: Timeframe (conditional)
                  _buildActivityLevelPage(),    // 8: Activity Level
                  _buildCompletePage(),         // 9: Complete
                ],
              ),
            ),
            
            // Full-width Continue button at bottom
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _getNextButtonText(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
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
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Your Personal\nNutrition Coach',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Let\'s create a personalized plan to help you achieve your health goals.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.timer,
                  color: Colors.blue[700],
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  'Takes only 2 minutes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Answer a few questions to get started with your personalized nutrition plan.',
                  style: TextStyle(color: Colors.blue[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgePage() {
    return _buildQuestionPage(
      question: 'How old are you?',
      subtitle: 'This helps us calculate your metabolic rate accurately.',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: _ageController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Enter your age',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixText: 'years old',
            suffixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderPage() {
    return _buildQuestionPage(
      question: 'What\'s your gender?',
      subtitle: 'Men and women have different caloric needs due to differences in muscle mass and metabolism.',
      child: Column(
        children: [
          _buildGenderOption('male', 'Male', Icons.male),
          const SizedBox(height: 16),
          _buildGenderOption('female', 'Female', Icons.female),
        ],
      ),
    );
  }

  Widget _buildHeightPage() {
    return _buildQuestionPage(
      question: 'What\'s your height?',
      subtitle: 'Height is a key factor in determining your daily calorie needs.',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Enter height',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixText: 'cm',
            suffixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeightPage() {
    return _buildQuestionPage(
      question: 'What\'s your current weight?',
      subtitle: 'Be honest - this information is kept private and helps us create the best plan for you.',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: _weightController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Enter weight',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixText: 'kg',
            suffixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTypePage() {
    return _buildQuestionPage(
      question: 'What\'s your primary goal?',
      subtitle: 'Choose the goal that best describes what you want to achieve.',
      child: Column(
        children: [
          _buildGoalTypeOption(
            'lose_weight',
            'Lose Weight',
            'Reduce body weight and improve body composition',
            Icons.trending_down,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildGoalTypeOption(
            'maintain_weight',
            'Maintain Weight',
            'Keep current weight and build healthy habits',
            Icons.balance,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWeightPage() {
    if (_selectedGoal == 'maintain_weight') return Container();
    
    return _buildQuestionPage(
      question: 'What\'s your target weight?',
      subtitle: _selectedGoal == 'lose_weight' 
        ? 'Set a realistic goal. Healthy weight loss is 0.5-1 kg per week.'
        : 'Set a healthy goal. Aim for gradual weight gain through muscle building.',
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextFormField(
          controller: _targetWeightController,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Target weight',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
            suffixText: 'kg',
            suffixStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeframePage() {
    if (_selectedGoal == 'maintain_weight') return Container();
    
    return _buildQuestionPage(
      question: 'What\'s your target timeframe?',
      subtitle: 'Sustainable changes take time. Choose a realistic timeframe for lasting results.',
      child: Column(
        children: [
          _buildTimeframeOptionCard('3_months', '3 Months', 'Quick but sustainable results', Icons.flash_on),
          const SizedBox(height: 12),
          _buildTimeframeOptionCard('6_months', '6 Months', 'Balanced and steady progress', Icons.trending_up),
          const SizedBox(height: 12),
          _buildTimeframeOptionCard('1_year', '1 Year', 'Gradual lifestyle transformation', Icons.emoji_events),
          const SizedBox(height: 12),
          _buildTimeframeOptionCard('custom', 'My Own Pace', 'Flexible timeline', Icons.self_improvement),
        ],
      ),
    );
  }

  Widget _buildActivityLevelPage() {
    return _buildQuestionPage(
      question: 'How active are you?',
      subtitle: 'Be honest about your current activity level - you can always increase it later!',
      child: Column(
        children: [
          _buildActivityCard('sedentary', 'Mostly Sitting', 'Office job, little to no exercise', Icons.weekend),
          const SizedBox(height: 12),
          _buildActivityCard('light', 'Lightly Active', 'Light exercise 1-3 days per week', Icons.directions_walk),
          const SizedBox(height: 12),
          _buildActivityCard('moderate', 'Moderately Active', 'Moderate exercise 3-5 days per week', Icons.fitness_center),
          const SizedBox(height: 12),
          _buildActivityCard('very', 'Very Active', 'Hard exercise 6-7 days per week', Icons.sports_gymnastics),
        ],
      ),
    );
  }

  Widget _buildQuestionPage({
    required String question,
    required String subtitle,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            question,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          child,
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String value, String title, IconData icon) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 60), // Increased touch target
        padding: const EdgeInsets.all(24), // More padding for easier tapping
        margin: const EdgeInsets.only(bottom: 8), // More spacing between elements
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[50],
          borderRadius: BorderRadius.circular(18), // Larger radius
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14), // Larger icon container
              decoration: BoxDecoration(
                color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey[400],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28, // Larger icon
              ),
            ),
            const SizedBox(width: 20), // More spacing
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 18, // Larger text
                color: isSelected 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTypeOption(String value, String title, String description, IconData icon, Color color) {
    final isSelected = _selectedGoal == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoal = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 76), // Larger touch target
        padding: const EdgeInsets.all(24), // More padding
        margin: const EdgeInsets.only(bottom: 12), // More spacing between elements
        decoration: BoxDecoration(
          color: isSelected 
            ? color.withOpacity(0.1)
            : Colors.grey[50],
          borderRadius: BorderRadius.circular(18), // Larger radius
          border: Border.all(
            color: isSelected 
              ? color
              : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14), // Larger icon container
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.grey[400],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28, // Larger icon
              ),
            ),
            const SizedBox(width: 20), // More spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 18, // Larger text
                      color: isSelected ? color : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 6), // More spacing
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15, // Slightly larger description text
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

  Widget _buildTimeframeOptionCard(String value, String title, String description, IconData icon) {
    final isSelected = _selectedTimeframe == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeframe = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 60), // Larger touch target
        padding: const EdgeInsets.all(20), // More padding
        margin: const EdgeInsets.only(bottom: 8), // More spacing between elements
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[50],
          borderRadius: BorderRadius.circular(16), // Larger radius
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[600],
              size: 24, // Larger icon
            ),
            const SizedBox(width: 16), // More spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 17, // Larger text
                      color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4), // More spacing
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14, // Larger description text
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

  Widget _buildActivityCard(String value, String title, String description, IconData icon) {
    final isSelected = _selectedActivityLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedActivityLevel = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 60), // Larger touch target
        padding: const EdgeInsets.all(20), // More padding
        margin: const EdgeInsets.only(bottom: 8), // More spacing between elements
        decoration: BoxDecoration(
          color: isSelected 
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[50],
          borderRadius: BorderRadius.circular(16), // Larger radius
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[600],
              size: 24, // Larger icon
            ),
            const SizedBox(width: 16), // More spacing
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 17, // Larger text
                      color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4), // More spacing
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14, // Larger description text
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
        return 'Continue';
      case 5:
        return 'Continue';
      case 6:
        return 'Continue';
      case 7:
        return 'Continue';
      case 8:
        return 'Continue';
      case 9:
        return 'Start Using App';
      default:
        return 'Next';
    }
  }

  void _nextPage() async {
    // Validation for each page
    if (_currentPage == 1) {
      // Age page
      if (_ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your age')),
        );
        return;
      }
      final age = int.tryParse(_ageController.text);
      if (age == null || age < 10 || age > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid age (10-120)')),
        );
        return;
      }
    } else if (_currentPage == 2) {
      // Gender page
      if (_selectedGender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
    } else if (_currentPage == 3) {
      // Height page
      if (_heightController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your height')),
        );
        return;
      }
      final height = double.tryParse(_heightController.text);
      if (height == null || height < 100 || height > 250) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid height (100-250 cm)')),
        );
        return;
      }
    } else if (_currentPage == 4) {
      // Current weight page
      if (_weightController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your weight')),
        );
        return;
      }
      final weight = double.tryParse(_weightController.text);
      if (weight == null || weight < 30 || weight > 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid weight (30-300 kg)')),
        );
        return;
      }
    } else if (_currentPage == 5) {
      // Goal type page
      if (_selectedGoal.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your goal')),
        );
        return;
      }
    } else if (_currentPage == 6) {
      // Target weight page (conditional)
      if (_selectedGoal != 'maintain_weight') {
        if (_targetWeightController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter your target weight')),
          );
          return;
        }
        final targetWeight = double.tryParse(_targetWeightController.text);
        if (targetWeight == null || targetWeight < 30 || targetWeight > 300) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid target weight (30-300 kg)')),
          );
          return;
        }
      }
    } else if (_currentPage == 7) {
      // Timeframe page (conditional)
      if (_selectedGoal != 'maintain_weight') {
        if (_selectedTimeframe.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a timeframe')),
          );
          return;
        }
      }
    } else if (_currentPage == 8) {
      // Activity level page
      if (_selectedActivityLevel.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your activity level')),
        );
        return;
      }
    } else if (_currentPage == 9) {
      // Complete page - save data and navigate to main app
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
        
        await _setupService.markSetupComplete();
        
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacementNamed('/main');
        return;
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
        return;
      }
    }
    
    // Handle conditional navigation for maintain_weight goal
    if (_selectedGoal == 'maintain_weight') {
      if (_currentPage == 5) {
        // Skip pages 6 and 7 (target weight and timeframe)
        _pageController.animateToPage(
          8, // Go directly to activity level page
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
    
    // Regular navigation
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    // Handle conditional navigation for maintain_weight goal
    if (_selectedGoal == 'maintain_weight' && _currentPage == 8) {
      // Skip back over pages 6 and 7 (target weight and timeframe)
      _pageController.animateToPage(
        5, // Go back to goal type page
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }
    
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


}