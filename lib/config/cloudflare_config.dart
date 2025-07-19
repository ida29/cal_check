import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudflareConfig {
  // Cloudflare Images configuration
  // Get your API token from: https://dash.cloudflare.com/profile/api-tokens
  // Get your account ID from: https://dash.cloudflare.com/ (right sidebar)
  
  /// Get Cloudflare API token from environment variables
  static String get apiToken {
    return dotenv.env['CLOUDFLARE_API_TOKEN'] ?? '';
  }
  
  /// Get Cloudflare account ID from environment variables
  static String get accountId {
    return dotenv.env['CLOUDFLARE_ACCOUNT_ID'] ?? '';
  }
  
  /// Get custom domain or use default
  static String get deliveryUrl {
    final customDomain = dotenv.env['CLOUDFLARE_CUSTOM_DOMAIN'];
    if (customDomain != null && customDomain.isNotEmpty) {
      return 'https://$customDomain';
    }
    
    // Default Cloudflare Images URL format
    return 'https://imagedelivery.net/${dotenv.env['CLOUDFLARE_IMAGE_HASH'] ?? 'your-hash'}';
  }
  
  /// Cloudflare API base URL
  static const String apiBaseUrl = 'https://api.cloudflare.com/client/v4';
  
  /// Check if Cloudflare is properly configured
  static bool get isConfigured {
    return apiToken.isNotEmpty && 
           accountId.isNotEmpty && 
           apiToken != 'your-cloudflare-api-token-here' &&
           accountId != 'your-cloudflare-account-id-here';
  }
  
  /// Image upload limits and settings
  static const int maxImageSizeMB = 10;
  static const List<String> supportedFormats = ['jpg', 'jpeg', 'png', 'webp', 'gif'];
  
  /// Image optimization settings
  static const Map<String, String> defaultTransforms = {
    'thumbnail': 'w=150,h=150,fit=cover,f=webp',
    'small': 'w=300,h=300,fit=cover,f=webp',
    'medium': 'w=600,h=600,fit=scale-down,f=webp',
    'large': 'w=1200,h=1200,fit=scale-down,f=webp',
  };
  
  /// Pricing information (approximate, as of 2024)
  static const Map<String, dynamic> pricing = {
    'storage': {
      'free_tier': '100,000 images',
      'paid_tier': '\$5 per 100,000 images/month',
    },
    'delivery': {
      'free_tier': '100,000 requests',
      'paid_tier': '\$1 per 100,000 requests',
    },
    'transformations': {
      'note': 'Real-time transformations included',
    },
  };
  
  /// Get image URL with transformations
  static String getImageUrl(String imageId, {String? transform}) {
    if (!isConfigured) return '';
    
    final baseUrl = '$deliveryUrl/$imageId';
    
    if (transform != null && defaultTransforms.containsKey(transform)) {
      return '$baseUrl/${defaultTransforms[transform]}';
    }
    
    return '$baseUrl/public';
  }
}