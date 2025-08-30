import 'package:flutter/material.dart';
import '../../../services/embedded_ytdlp_service.dart';
import '../../../services/download_queue_service.dart';
import '../../../services/file_manager_service.dart';
import '../types.dart';
import '../constants.dart';
import '../utils.dart';

/// Hook for managing download operations and state
class UseDownloadManagement extends ChangeNotifier {
  DownloadState _state = const DownloadState(
    isDownloading: false,
    status: '',
    effectiveDownloadPath: '',
    downloadedFilePath: '',
    ytDlpAvailable: false,
  );
  
  DownloadOptions _options = const DownloadOptions(
    format: DownloaderConstants.defaultFormat,
    quality: DownloaderConstants.defaultQuality,
    audioOnly: false,
    downloadSubtitles: false,
  );
  
  late DownloadQueueService _queueService;
  
  DownloadState get state => _state;
  DownloadOptions get options => _options;
  DownloadQueueService get queueService => _queueService;
  
  UseDownloadManagement() {
    _queueService = DownloadQueueService();
    _initialize();
  }
  
  Future<void> _initialize() async {
    await checkYtDlpAvailability();
  }
  
  /// Updates download options
  void updateOptions(DownloadOptions newOptions) {
    _options = newOptions;
    notifyListeners();
  }
  
  /// Updates a specific option field
  void updateOption({
    String? format,
    String? quality,
    bool? audioOnly,
    bool? downloadSubtitles,
  }) {
    _options = _options.copyWith(
      format: format,
      quality: quality,
      audioOnly: audioOnly,
      downloadSubtitles: downloadSubtitles,
    );
    notifyListeners();
  }
  
  /// Checks if yt-dlp is available
  Future<void> checkYtDlpAvailability() async {
    final isAvailable = await EmbeddedYtDlpService.isAvailable();
    _state = _state.copyWith(ytDlpAvailable: isAvailable);
    notifyListeners();
  }
  
  /// Validates a YouTube URL
  bool isValidUrl(String url) {
    return DownloaderUtils.isValidYouTubeUrl(url);
  }
  
  /// Initiates a video download
  Future<void> downloadVideo({
    required BuildContext context,
    required String url,
    required String outputPath,
  }) async {
    if (!isValidUrl(url)) {
      DownloaderUtils.showErrorSnackBar(context, 'Please enter a valid YouTube URL');
      return;
    }
    
    if (!_state.ytDlpAvailable) {
      DownloaderUtils.showErrorSnackBar(context, DownloaderConstants.ytDlpUnavailableMessage);
      return;
    }
    
    // Get the effective download path
    final downloadPath = await FileManagerService.getEffectiveDownloadPath(
      outputPath.trim().isEmpty ? null : outputPath.trim(),
    );
    
    // Check if directory exists and create if needed
    final directoryExists = await FileManagerService.ensureDirectoryExists(downloadPath);
    if (!directoryExists) {
      DownloaderUtils.showErrorSnackBar(context, 'Cannot create download directory: $downloadPath');
      return;
    }
    
    // Check write permissions
    final hasPermission = await FileManagerService.hasWritePermission(downloadPath);
    if (!hasPermission) {
      DownloaderUtils.showErrorSnackBar(context, 'No write permission for directory: $downloadPath');
      return;
    }
    
    _state = _state.copyWith(
      isDownloading: true,
      status: DownloaderConstants.startingDownloadMessage,
      effectiveDownloadPath: downloadPath,
      downloadedFilePath: '',
    );
    notifyListeners();
    
    try {
      // Add to download queue
      final downloadId = await _queueService.addDownload(
        url: url,
        outputPath: downloadPath,
        format: _options.format,
        quality: _options.quality,
        audioOnly: _options.audioOnly,
        downloadSubtitles: _options.downloadSubtitles,
      );
      
      _state = _state.copyWith(
        status: 'Added to download queue (ID: $downloadId)',
      );
      notifyListeners();
      
      DownloaderUtils.showSuccessSnackBar(context, 'Download added to queue! Check the Queue tab to monitor progress.');
      
    } catch (e) {
      _state = _state.copyWith(
        status: 'Failed to add to queue: ${e.toString()}',
      );
      notifyListeners();
      
      DownloaderUtils.showErrorSnackBar(context, 'Failed to add to queue: ${e.toString()}');
    } finally {
      _state = _state.copyWith(isDownloading: false);
      notifyListeners();
    }
  }
  
  /// Clears the download status
  void clearStatus() {
    _state = _state.copyWith(status: '');
    notifyListeners();
  }
}
