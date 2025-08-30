import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../services/file_manager_service.dart';
import '../utils.dart';

/// Hook for managing file paths and folder operations
class UsePathManagement extends ChangeNotifier {
  final TextEditingController _outputPathController = TextEditingController();
  String _effectiveDownloadPath = '';
  
  TextEditingController get outputPathController => _outputPathController;
  String get effectiveDownloadPath => _effectiveDownloadPath;
  
  UsePathManagement() {
    _loadDefaultPath();
  }
  
  @override
  void dispose() {
    _outputPathController.dispose();
    super.dispose();
  }
  
  /// Loads the default download path
  Future<void> _loadDefaultPath() async {
    final defaultPath = await FileManagerService.getDefaultDownloadPath();
    final savedPath = await FileManagerService.getSavedDownloadPath();
    
    _effectiveDownloadPath = savedPath ?? defaultPath;
    if (_outputPathController.text.isEmpty) {
      _outputPathController.text = _effectiveDownloadPath;
    }
    notifyListeners();
  }
  
  /// Opens folder selection dialog
  Future<void> selectDownloadFolder(BuildContext context) async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        _outputPathController.text = selectedDirectory;
        _effectiveDownloadPath = selectedDirectory;
        notifyListeners();
      }
    } catch (e) {
      DownloaderUtils.showErrorSnackBar(context, 'Failed to select folder: ${e.toString()}');
    }
  }
  
  /// Opens the current download folder in file explorer
  Future<void> openDownloadFolder(BuildContext context) async {
    final path = _outputPathController.text;
    if (path.isNotEmpty) {
      try {
        await DownloaderUtils.openDownloadFolder(path);
      } catch (e) {
        DownloaderUtils.showErrorSnackBar(context, e.toString());
      }
    }
  }
  
  /// Updates the output path manually
  void updateOutputPath(String path) {
    _outputPathController.text = path;
    _effectiveDownloadPath = path;
    notifyListeners();
  }
}
