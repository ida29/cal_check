import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import '../../config/cloudflare_config.dart';

class CloudflareImagesService {
  static final CloudflareImagesService _instance = CloudflareImagesService._internal();
  factory CloudflareImagesService() => _instance;
  CloudflareImagesService._internal();

  final Dio _dio = Dio();

  /// Upload an image to Cloudflare Images
  /// Returns the image URL on success
  Future<String?> uploadImage(String imagePath, {String? metadata}) async {
    try {
      if (!CloudflareConfig.isConfigured) {
        print('Cloudflare Images not configured, skipping upload');
        return null;
      }

      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: $imagePath');
      }

      final fileName = path.basename(imagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final customId = 'meal_${timestamp}_${fileName.split('.').first}';

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
          filename: fileName,
        ),
        'id': customId,
        if (metadata != null) 'metadata': metadata,
        'requireSignedURLs': 'false', // Allow public access for now
      });

      final response = await _dio.post(
        '${CloudflareConfig.apiBaseUrl}/accounts/${CloudflareConfig.accountId}/images/v1',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CloudflareConfig.apiToken}',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = response.data['result'];
        if (result != null) {
          // Return the public URL
          final imageId = result['id'];
          final variants = result['variants'] as List?;
          
          // Return the public variant URL, or construct one
          if (variants != null && variants.isNotEmpty) {
            return variants.first as String;
          } else {
            // Construct public URL
            return '${CloudflareConfig.deliveryUrl}/${imageId}/public';
          }
        }
      }

      print('Upload failed with status: ${response.statusCode}');
      print('Response: ${response.data}');
      return null;
    } catch (e) {
      print('Error uploading image to Cloudflare: $e');
      return null;
    }
  }

  /// Upload image with meal data
  Future<String?> uploadMealImage(
    String imagePath, {
    required String mealType,
    required double totalCalories,
    required List<String> detectedFoods,
  }) async {
    final metadata = json.encode({
      'type': 'meal',
      'mealType': mealType,
      'totalCalories': totalCalories,
      'detectedFoods': detectedFoods,
      'uploadedAt': DateTime.now().toIso8601String(),
    });

    return await uploadImage(imagePath, metadata: metadata);
  }

  /// Get image details from Cloudflare
  Future<Map<String, dynamic>?> getImageDetails(String imageId) async {
    try {
      if (!CloudflareConfig.isConfigured) {
        return null;
      }

      final response = await _dio.get(
        '${CloudflareConfig.apiBaseUrl}/accounts/${CloudflareConfig.accountId}/images/v1/$imageId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CloudflareConfig.apiToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['result'];
      }

      return null;
    } catch (e) {
      print('Error getting image details: $e');
      return null;
    }
  }

  /// List uploaded images with pagination
  Future<List<Map<String, dynamic>>> listImages({
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      if (!CloudflareConfig.isConfigured) {
        return [];
      }

      final response = await _dio.get(
        '${CloudflareConfig.apiBaseUrl}/accounts/${CloudflareConfig.accountId}/images/v1',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CloudflareConfig.apiToken}',
          },
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data['result'];
        if (result != null && result['images'] != null) {
          return List<Map<String, dynamic>>.from(result['images']);
        }
      }

      return [];
    } catch (e) {
      print('Error listing images: $e');
      return [];
    }
  }

  /// Delete an image from Cloudflare
  Future<bool> deleteImage(String imageId) async {
    try {
      if (!CloudflareConfig.isConfigured) {
        return false;
      }

      final response = await _dio.delete(
        '${CloudflareConfig.apiBaseUrl}/accounts/${CloudflareConfig.accountId}/images/v1/$imageId',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${CloudflareConfig.apiToken}',
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Generate different sized URLs for responsive images
  Map<String, String> getImageVariants(String imageId) {
    if (!CloudflareConfig.isConfigured) {
      return {};
    }

    final baseUrl = '${CloudflareConfig.deliveryUrl}/$imageId';
    
    return {
      'thumbnail': '$baseUrl/w=150,h=150,fit=cover',
      'small': '$baseUrl/w=300,h=300,fit=cover',
      'medium': '$baseUrl/w=600,h=600,fit=scale-down',
      'large': '$baseUrl/w=1200,h=1200,fit=scale-down',
      'original': '$baseUrl/public',
    };
  }

  void dispose() {
    _dio.close();
  }
}