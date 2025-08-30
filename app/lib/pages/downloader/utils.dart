import 'dart:io';
import 'package:flutter/material.dart';
import 'constants.dart';

/// Utility functions for the downloader functionality
class DownloaderUtils {
  /// Validates if the provided URL is a valid YouTube URL
  static bool isValidYouTubeUrl(String url) {
    if (url.trim().isEmpty) return false;
    
    return DownloaderConstants.validYouTubePatterns.any(
      (pattern) => url.contains(pattern),
    );
  }
  
  /// Opens the download folder in the system file explorer
  static Future<void> openDownloadFolder(String path) async {
    if (path.isEmpty) return;
    
    try {
      if (Platform.isWindows) {
        await Process.run('explorer', [path]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [path]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [path]);
      }
    } catch (e) {
      throw Exception('Could not open folder: ${e.toString()}');
    }
  }
  
  /// Shows an error snackbar with the given message
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
  
  /// Shows a success snackbar with the given message
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
