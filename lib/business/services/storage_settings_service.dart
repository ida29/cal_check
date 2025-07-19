import 'package:shared_preferences/shared_preferences.dart';
import 'local_photo_storage_service.dart';

class StorageSettingsService {
  static final StorageSettingsService _instance = StorageSettingsService._internal();
  factory StorageSettingsService() => _instance;
  StorageSettingsService._internal();

  static const String _retentionDaysKey = 'photo_retention_days';
  static const String _autoCleanupEnabledKey = 'auto_cleanup_enabled';
  static const String _maxPhotosKey = 'max_photos_before_cleanup';

  /// Get current retention period in days
  Future<int> getRetentionDays() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_retentionDaysKey) ?? LocalPhotoStorageService.defaultRetentionDays;
  }

  /// Set retention period in days
  Future<void> setRetentionDays(int days) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_retentionDaysKey, days);
  }

  /// Get auto cleanup enabled status
  Future<bool> isAutoCleanupEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoCleanupEnabledKey) ?? true;
  }

  /// Set auto cleanup enabled status
  Future<void> setAutoCleanupEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoCleanupEnabledKey, enabled);
  }

  /// Get max photos before cleanup
  Future<int> getMaxPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_maxPhotosKey) ?? LocalPhotoStorageService.maxPhotosBeforeCleanup;
  }

  /// Set max photos before cleanup
  Future<void> setMaxPhotos(int maxPhotos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_maxPhotosKey, maxPhotos);
  }

  /// Get retention option name from days
  String getRetentionOptionName(int days) {
    for (final entry in LocalPhotoStorageService.retentionOptions.entries) {
      if (entry.value == days) {
        return entry.key;
      }
    }
    return '${days}日間';
  }

  /// Get all available retention options
  Map<String, int> getRetentionOptions() {
    return Map.from(LocalPhotoStorageService.retentionOptions);
  }

  /// Apply settings with immediate cleanup if needed
  Future<void> applyRetentionSettings({
    int? retentionDays,
    bool? autoCleanupEnabled,
    int? maxPhotos,
    bool forceCleanupNow = false,
  }) async {
    if (retentionDays != null) {
      await setRetentionDays(retentionDays);
    }
    
    if (autoCleanupEnabled != null) {
      await setAutoCleanupEnabled(autoCleanupEnabled);
    }
    
    if (maxPhotos != null) {
      await setMaxPhotos(maxPhotos);
    }

    // Trigger cleanup if requested or if auto cleanup is enabled
    final shouldCleanup = forceCleanupNow || (await isAutoCleanupEnabled());
    if (shouldCleanup) {
      final storageService = LocalPhotoStorageService();
      final currentRetentionDays = await getRetentionDays();
      await storageService.cleanupExpiredPhotos(retentionDays: currentRetentionDays);
    }
  }

  /// Get storage summary with current settings
  Future<Map<String, dynamic>> getStorageSummary() async {
    final storageService = LocalPhotoStorageService();
    final storageInfo = await storageService.getStorageInfo();
    
    final retentionDays = await getRetentionDays();
    final autoCleanupEnabled = await isAutoCleanupEnabled();
    final maxPhotos = await getMaxPhotos();

    return {
      ...storageInfo,
      'settings': {
        'retentionDays': retentionDays,
        'retentionOptionName': getRetentionOptionName(retentionDays),
        'autoCleanupEnabled': autoCleanupEnabled,
        'maxPhotos': maxPhotos,
      },
    };
  }

  /// Reset to default settings
  Future<void> resetToDefaults() async {
    await setRetentionDays(LocalPhotoStorageService.defaultRetentionDays);
    await setAutoCleanupEnabled(true);
    await setMaxPhotos(LocalPhotoStorageService.maxPhotosBeforeCleanup);
  }
}