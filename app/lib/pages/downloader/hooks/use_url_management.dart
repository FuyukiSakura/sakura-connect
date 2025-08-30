import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils.dart';

/// Hook for managing URL input and clipboard operations
class UseUrlManagement extends ChangeNotifier {
  final TextEditingController _urlController = TextEditingController();
  
  TextEditingController get urlController => _urlController;
  String get url => _urlController.text.trim();
  bool get hasValidUrl => DownloaderUtils.isValidYouTubeUrl(url);
  
  UseUrlManagement() {
    _urlController.addListener(() {
      notifyListeners();
    });
  }
  
  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
  
  /// Pastes URL from clipboard
  Future<void> pasteFromClipboard(BuildContext context) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        _urlController.text = clipboardData!.text!;
        notifyListeners();
      }
    } catch (e) {
      DownloaderUtils.showErrorSnackBar(context, 'Failed to paste from clipboard');
    }
  }
  
  /// Clears the URL input
  void clearUrl() {
    _urlController.clear();
    notifyListeners();
  }
  
  /// Sets a specific URL
  void setUrl(String url) {
    _urlController.text = url;
    notifyListeners();
  }
}
