import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileManagerService {
  static const String _defaultPathKey = 'default_download_path';

  /// Get the default download directory
  static Future<String> getDefaultDownloadPath() async {
    try {
      if (Platform.isAndroid) {
        // For Android, try to get the Downloads directory
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          final downloadsPath = '${directory.parent.parent.parent.parent.path}/Download';
          final downloadsDir = Directory(downloadsPath);
          if (await downloadsDir.exists()) {
            return downloadsPath;
          }
        }
        // Fallback to app's external storage directory
        final appDir = await getExternalStorageDirectory();
        return appDir?.path ?? '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        // For iOS, use the app's documents directory
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
      } else if (Platform.isWindows) {
        // For Windows, use the Downloads folder
        final userProfile = Platform.environment['USERPROFILE'];
        if (userProfile != null) {
          return '$userProfile\\Downloads';
        }
        return 'C:\\Users\\Downloads';
      } else if (Platform.isMacOS) {
        // For macOS, use the Downloads folder
        final home = Platform.environment['HOME'];
        if (home != null) {
          return '$home/Downloads';
        }
        return '/Users/Downloads';
      } else if (Platform.isLinux) {
        // For Linux, use the Downloads folder
        final home = Platform.environment['HOME'];
        if (home != null) {
          return '$home/Downloads';
        }
        return '/home/Downloads';
      }
    } catch (e) {
      // Fallback to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    
    // Final fallback
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Get the saved default download path from preferences
  static Future<String?> getSavedDownloadPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultPathKey);
  }

  /// Save the default download path to preferences
  static Future<void> saveDownloadPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultPathKey, path);
  }

  /// Get the effective download path (user specified or default)
  static Future<String> getEffectiveDownloadPath(String? userSpecifiedPath) async {
    if (userSpecifiedPath != null && userSpecifiedPath.trim().isNotEmpty) {
      return userSpecifiedPath.trim();
    }
    
    // Try to get saved path first
    final savedPath = await getSavedDownloadPath();
    if (savedPath != null) {
      return savedPath;
    }
    
    // Fall back to default
    return await getDefaultDownloadPath();
  }

  /// Create directory if it doesn't exist
  static Future<bool> ensureDirectoryExists(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if we have permission to write to the specified directory
  static Future<bool> hasWritePermission(String path) async {
    try {
      if (Platform.isAndroid) {
        // Check storage permission
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        return true;
      }
      
      // For other platforms, try to create a test file
      final testFile = File('$path/.test_write_permission');
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get file size in a human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Generate a safe filename from video title
  static String generateSafeFilename(String title, String extension) {
    // Remove or replace invalid characters
    String safeTitle = title
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    
    // Limit length to avoid filesystem issues
    if (safeTitle.length > 100) {
      safeTitle = safeTitle.substring(0, 100);
    }
    
    return '$safeTitle.$extension';
  }

  /// Check available disk space
  static Future<int?> getAvailableSpace(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        // This is a simplified check - in a real implementation,
        // you might want to use platform-specific methods
        return null; // Placeholder - would need platform channels for accurate disk space
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }
}
