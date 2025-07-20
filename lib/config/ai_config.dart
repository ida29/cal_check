import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIConfig {
  // Available models through OpenRouter
  static const Map<String, String> availableModels = {
    // Best for Japanese food recognition
    'gpt-4o': 'openai/gpt-4o', // GPT-4o - Best for Japanese food, used in FoodMLLM-JP research
    'qwen-vl-7b': 'qwen/qwen-2.5-vl-7b-instruct', // Qwen2.5 VL - Excellent multilingual including Japanese
    'llama-vision-11b': 'meta-llama/llama-3.2-11b-vision-instruct', // Llama 3.2 Vision - Good for visual reasoning
    
    // Previous models (kept for compatibility)
    'claude-3-haiku': 'anthropic/claude-3-haiku:beta', // Fastest and cheapest
    'claude-3-sonnet': 'anthropic/claude-3-sonnet:beta', // Balanced
    'gpt-4-vision': 'openai/gpt-4-vision-preview', // Legacy GPT-4 vision
    'gemini-pro-vision': 'google/gemini-pro-vision', // Google's vision model
  };
  
  // Model pricing (approximate, in USD per 1K tokens)
  static const Map<String, Map<String, double>> modelPricing = {
    'gpt-4o': {'input': 0.005, 'output': 0.015}, // GPT-4o pricing
    'qwen-vl-7b': {'input': 0.0004, 'output': 0.0004}, // Qwen is typically cheaper
    'llama-vision-11b': {'input': 0.00055, 'output': 0.00055}, // Llama pricing
    
    // Previous models pricing
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
    return dotenv.env['AI_MODEL'] ?? 'gpt-4o'; // Default to GPT-4o for best Japanese food recognition
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