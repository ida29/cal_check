import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../data/entities/food_item.dart';
import '../../data/entities/nutrition_info.dart';

class LocalPhotoStorageService {
  static final LocalPhotoStorageService _instance = LocalPhotoStorageService._internal();
  factory LocalPhotoStorageService() => _instance;
  LocalPhotoStorageService._internal();

  static const String _photosDir = 'meal_photos';
  static const String _metadataFile = 'photo_metadata.json';
  
  // Storage settings
  static const int defaultRetentionDays = 90; // 3 months
  static const int maxPhotosBeforeCleanup = 500; // Increased for longer retention
  
  // Available retention periods for user selection
  static const Map<String, int> retentionOptions = {
    '1週間': 7,
    '1ヶ月': 30,
    '3ヶ月': 90,
    '6ヶ月': 180,
    '1年': 365,
    '無制限': -1, // Never auto-delete
  };

  /// Get the directory for storing meal photos
  Future<Directory> _getPhotosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(path.join(appDir.path, _photosDir));
    
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    
    return photosDir;
  }

  /// Save a meal photo with metadata
  Future<String?> saveMealPhoto({
    required String originalPath,
    required List<FoodItem> foodItems,
    required double totalCalories,
    required String mealType,
    bool isManualEntry = false,
    DateTime? createdAt,
  }) async {
    try {
      final photosDir = await _getPhotosDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      String savedPath;
      String filename;
      
      if (isManualEntry) {
        // 手動入力の場合はダミーパスを使用
        filename = 'manual_entry_$timestamp.json';
        savedPath = path.join(photosDir.path, filename);
      } else {
        final originalFile = File(originalPath);
        
        if (!await originalFile.exists()) {
          throw Exception('Original photo file does not exist');
        }

        // Generate unique filename
        final extension = path.extension(originalPath);
        filename = 'meal_${timestamp}$extension';
        savedPath = path.join(photosDir.path, filename);

        // Copy the image file
        await originalFile.copy(savedPath);
      }

      // Create metadata
      final metadata = MealPhotoMetadata(
        id: 'meal_$timestamp',
        filename: filename,
        savedPath: savedPath,
        originalPath: originalPath,
        foodItems: foodItems,
        totalCalories: totalCalories,
        mealType: mealType,
        createdAt: createdAt ?? DateTime.now(),
        fileSize: isManualEntry ? 0 : await File(savedPath).length(),
      );

      // Save metadata
      await _saveMetadata(metadata);

      // Auto cleanup if needed
      await _autoCleanupIfNeeded();

      print('Photo saved successfully: $savedPath');
      return savedPath;
    } catch (e) {
      print('Error saving meal photo: $e');
      return null;
    }
  }

  /// Save metadata to JSON file
  Future<void> _saveMetadata(MealPhotoMetadata metadata) async {
    try {
      final photosDir = await _getPhotosDirectory();
      final metadataFile = File(path.join(photosDir.path, _metadataFile));

      List<Map<String, dynamic>> allMetadata = [];
      
      // Read existing metadata
      if (await metadataFile.exists()) {
        final content = await metadataFile.readAsString();
        if (content.isNotEmpty) {
          final decoded = json.decode(content);
          if (decoded is List) {
            allMetadata = List<Map<String, dynamic>>.from(decoded);
          }
        }
      }

      // Add new metadata
      allMetadata.add(metadata.toJson());

      // Write back to file
      await metadataFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(allMetadata)
      );
    } catch (e) {
      print('Error saving metadata: $e');
    }
  }

  /// Get all saved meal photos
  Future<List<MealPhotoMetadata>> getAllMealPhotos() async {
    try {
      final photosDir = await _getPhotosDirectory();
      final metadataFile = File(path.join(photosDir.path, _metadataFile));

      if (!await metadataFile.exists()) {
        return [];
      }

      final content = await metadataFile.readAsString();
      if (content.isEmpty) {
        return [];
      }

      final decoded = json.decode(content);
      if (decoded is! List) {
        return [];
      }

      return decoded
          .map((json) => MealPhotoMetadata.fromJson(json))
          .where((metadata) => File(metadata.savedPath).existsSync())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Latest first
    } catch (e) {
      print('Error loading meal photos: $e');
      return [];
    }
  }

  /// Get meal photos by date range
  Future<List<MealPhotoMetadata>> getMealPhotosByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allPhotos = await getAllMealPhotos();
    
    return allPhotos.where((photo) {
      // Include photos where createdAt is >= startDate and < endDate
      return !photo.createdAt.isBefore(startDate) && 
             photo.createdAt.isBefore(endDate);
    }).toList();
  }

  /// Get meal photos by meal type
  Future<List<MealPhotoMetadata>> getMealPhotosByType(String mealType) async {
    final allPhotos = await getAllMealPhotos();
    
    return allPhotos.where((photo) => photo.mealType == mealType).toList();
  }

  /// Delete a meal photo
  Future<bool> deleteMealPhoto(String photoId) async {
    try {
      final photosDir = await _getPhotosDirectory();
      final metadataFile = File(path.join(photosDir.path, _metadataFile));

      if (!await metadataFile.exists()) {
        return false;
      }

      // Read metadata
      final content = await metadataFile.readAsString();
      final decoded = json.decode(content) as List;
      final allMetadata = List<Map<String, dynamic>>.from(decoded);

      // Find and remove the photo
      final photoIndex = allMetadata.indexWhere((item) => item['id'] == photoId);
      if (photoIndex == -1) {
        return false;
      }

      final photoMetadata = MealPhotoMetadata.fromJson(allMetadata[photoIndex]);
      
      // Delete the image file
      final imageFile = File(photoMetadata.savedPath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }

      // Remove from metadata
      allMetadata.removeAt(photoIndex);

      // Write back to file
      await metadataFile.writeAsString(
        const JsonEncoder.withIndent('  ').convert(allMetadata)
      );

      return true;
    } catch (e) {
      print('Error deleting meal photo: $e');
      return false;
    }
  }

  /// Get storage usage information
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final photosDir = await _getPhotosDirectory();
      final photos = await getAllMealPhotos();
      
      int totalSize = 0;
      int photoCount = photos.length;
      
      for (final photo in photos) {
        totalSize += photo.fileSize;
      }

      // Get available space (approximation)
      final availableSpace = await _getAvailableSpace();

      // Calculate retention statistics
      final now = DateTime.now();
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      final oneMonthAgo = now.subtract(const Duration(days: 30));
      final threeMonthsAgo = now.subtract(const Duration(days: 90));
      
      final recentPhotos = photos.where((p) => p.createdAt.isAfter(oneWeekAgo)).length;
      final thisMonthPhotos = photos.where((p) => p.createdAt.isAfter(oneMonthAgo)).length;
      final lastThreeMonthsPhotos = photos.where((p) => p.createdAt.isAfter(threeMonthsAgo)).length;

      return {
        'photoCount': photoCount,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
        'availableSpaceGB': (availableSpace / (1024 * 1024 * 1024)).toStringAsFixed(2),
        'storageDirectory': photosDir.path,
        'retentionDays': defaultRetentionDays,
        'retentionPeriod': defaultRetentionDays == -1 ? '無制限' : '${defaultRetentionDays}日間',
        'statistics': {
          'lastWeek': recentPhotos,
          'lastMonth': thisMonthPhotos,
          'lastThreeMonths': lastThreeMonthsPhotos,
        },
        'oldestPhoto': photos.isNotEmpty ? photos.last.createdAt.toIso8601String() : null,
        'newestPhoto': photos.isNotEmpty ? photos.first.createdAt.toIso8601String() : null,
      };
    } catch (e) {
      print('Error getting storage info: $e');
      return {};
    }
  }

  /// Get available storage space (approximation)
  Future<int> _getAvailableSpace() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final stat = await tempDir.stat();
      // This is an approximation - actual implementation would vary by platform
      return 1024 * 1024 * 1024; // 1GB default
    } catch (e) {
      return 1024 * 1024 * 1024; // 1GB default
    }
  }

  /// Auto cleanup based on retention period and count
  Future<void> _autoCleanupIfNeeded() async {
    final photos = await getAllMealPhotos();
    
    // Skip if photo count is reasonable
    if (photos.length < maxPhotosBeforeCleanup) {
      return;
    }

    await cleanupExpiredPhotos();
  }

  /// Clean up photos older than retention period
  Future<int> cleanupExpiredPhotos({int retentionDays = defaultRetentionDays}) async {
    try {
      // Skip cleanup if unlimited retention is set
      if (retentionDays == -1) {
        return 0;
      }
      
      final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays));
      final photos = await getAllMealPhotos();
      
      final expiredPhotos = photos.where((photo) => 
        photo.createdAt.isBefore(cutoffDate)
      ).toList();

      if (expiredPhotos.isEmpty) {
        return 0;
      }

      for (final photo in expiredPhotos) {
        await deleteMealPhoto(photo.id);
      }

      print('Cleaned up ${expiredPhotos.length} expired photos (older than $retentionDays days)');
      return expiredPhotos.length;
    } catch (e) {
      print('Error during cleanup: $e');
      return 0;
    }
  }

  /// Clean up old photos (keep last N photos)
  Future<void> cleanupOldPhotos({int keepCount = 100}) async {
    try {
      final photos = await getAllMealPhotos();
      
      if (photos.length <= keepCount) {
        return; // No cleanup needed
      }

      // Sort by date (newest first) and get photos to delete
      photos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final photosToDelete = photos.skip(keepCount).toList();

      for (final photo in photosToDelete) {
        await deleteMealPhoto(photo.id);
      }

      print('Cleaned up ${photosToDelete.length} old photos');
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  /// Get photos that will expire soon (within next 7 days)
  Future<List<MealPhotoMetadata>> getPhotosExpiringSoon({
    int retentionDays = defaultRetentionDays,
    int warningDays = 7,
  }) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: retentionDays - warningDays));
    final expiryDate = DateTime.now().subtract(Duration(days: retentionDays));
    final photos = await getAllMealPhotos();
    
    return photos.where((photo) => 
      photo.createdAt.isBefore(cutoffDate) && 
      photo.createdAt.isAfter(expiryDate)
    ).toList();
  }
}

/// Metadata class for meal photos
class MealPhotoMetadata {
  final String id;
  final String filename;
  final String savedPath;
  final String originalPath;
  final List<FoodItem> foodItems;
  final double totalCalories;
  final String mealType;
  final DateTime createdAt;
  final int fileSize;

  MealPhotoMetadata({
    required this.id,
    required this.filename,
    required this.savedPath,
    required this.originalPath,
    required this.foodItems,
    required this.totalCalories,
    required this.mealType,
    required this.createdAt,
    required this.fileSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'savedPath': savedPath,
      'originalPath': originalPath,
      'foodItems': foodItems.map((item) => item.toJson()).toList(),
      'totalCalories': totalCalories,
      'mealType': mealType,
      'createdAt': createdAt.toIso8601String(),
      'fileSize': fileSize,
    };
  }

  factory MealPhotoMetadata.fromJson(Map<String, dynamic> json) {
    return MealPhotoMetadata(
      id: json['id'] ?? '',
      filename: json['filename'] ?? '',
      savedPath: json['savedPath'] ?? '',
      originalPath: json['originalPath'] ?? '',
      foodItems: (json['foodItems'] as List?)
          ?.map((item) => FoodItem.fromJson(item))
          .toList() ?? [],
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      mealType: json['mealType'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      fileSize: json['fileSize'] ?? 0,
    );
  }

  /// Get total nutrition from all food items
  NutritionInfo get totalNutrition {
    if (foodItems.isEmpty) {
      return const NutritionInfo(
        protein: 0,
        carbohydrates: 0,
        fat: 0,
        fiber: 0,
        sugar: 0,
      );
    }

    double totalProtein = 0;
    double totalCarbohydrates = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalSugar = 0;

    for (final item in foodItems) {
      final ratio = item.quantity / 100; // Nutrition info is typically per 100g
      totalProtein += item.nutritionInfo.protein * ratio;
      totalCarbohydrates += item.nutritionInfo.carbohydrates * ratio;
      totalFat += item.nutritionInfo.fat * ratio;
      totalFiber += item.nutritionInfo.fiber * ratio;
      totalSugar += item.nutritionInfo.sugar * ratio;
    }

    return NutritionInfo(
      protein: totalProtein,
      carbohydrates: totalCarbohydrates,
      fat: totalFat,
      fiber: totalFiber,
      sugar: totalSugar,
    );
  }
}