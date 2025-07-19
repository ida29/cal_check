import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIConfig {
  // Available models through OpenRouter
  static const Map<String, String> availableModels = {
    'claude-3-haiku': 'anthropic/claude-3-haiku:beta', // Fastest and cheapest
    'claude-3-sonnet': 'anthropic/claude-3-sonnet:beta', // Balanced
    'gpt-4-vision': 'openai/gpt-4-vision-preview', // Most accurate but expensive
    'gemini-pro-vision': 'google/gemini-pro-vision', // Google's vision model
  };
  
  // Model pricing (approximate, in USD per 1K tokens)
  static const Map<String, Map<String, double>> modelPricing = {
    'claude-3-haiku': {'input': 0.00025, 'output': 0.00125},
    'claude-3-sonnet': {'input': 0.003, 'output': 0.015},
    'gpt-4-vision': {'input': 0.01, 'output': 0.03},
    'gemini-pro-vision': {'input': 0.0005, 'output': 0.0015},
  };
  
  // Get OpenRouter API key from environment variables
  static String get openRouterApiKey {
    return dotenv.env['OPENROUTER_API_KEY'] ?? 'your-openrouter-api-key-here';
  }
  
  // Get AI model from environment variables or use default
  static String get selectedModel {
    return dotenv.env['AI_MODEL'] ?? 'claude-3-haiku';
  }
  
  // Get API configuration from environment variables
  static String get baseUrl {
    return dotenv.env['OPENROUTER_BASE_URL'] ?? 'https://openrouter.ai/api/v1';
  }
  
  static String get referer {
    return dotenv.env['HTTP_REFERER'] ?? 'https://calorie-checker-ai.com';
  }
  
  static String get appTitle {
    return dotenv.env['APP_TITLE'] ?? 'Calorie Checker AI';
  }
  
  // Check if API key is configured
  static bool get isConfigured => openRouterApiKey != 'your-openrouter-api-key-here' && openRouterApiKey.isNotEmpty;
  
  // Get the model to use
  static String get currentModel => availableModels[selectedModel] ?? availableModels['claude-3-haiku']!;
  
  // Initialize configuration (call this in main.dart)
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print('Warning: Could not load .env file: $e');
      print('Using default configuration or environment variables');
    }
  }
}