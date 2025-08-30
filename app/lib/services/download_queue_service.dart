import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'embedded_ytdlp_service.dart';

enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  cancelled,
  paused,
}

class DownloadItem {
  final String id;
  final String url;
  final String title;
  final String outputPath;
  final String format;
  final String quality;
  final bool audioOnly;
  final bool downloadSubtitles;
  
  DownloadStatus status;
  String progress;
  String? errorMessage;
  String? filePath;
  DateTime createdAt;
  DateTime? startedAt;
  DateTime? completedAt;
  
  DownloadItem({
    required this.id,
    required this.url,
    required this.title,
    required this.outputPath,
    required this.format,
    required this.quality,
    required this.audioOnly,
    required this.downloadSubtitles,
    this.status = DownloadStatus.queued,
    this.progress = 'Queued',
    this.errorMessage,
    this.filePath,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'title': title,
    'outputPath': outputPath,
    'format': format,
    'quality': quality,
    'audioOnly': audioOnly,
    'downloadSubtitles': downloadSubtitles,
    'status': status.index,
    'progress': progress,
    'errorMessage': errorMessage,
    'filePath': filePath,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'startedAt': startedAt?.millisecondsSinceEpoch,
    'completedAt': completedAt?.millisecondsSinceEpoch,
  };

  factory DownloadItem.fromJson(Map<String, dynamic> json) => DownloadItem(
    id: json['id'],
    url: json['url'],
    title: json['title'],
    outputPath: json['outputPath'],
    format: json['format'],
    quality: json['quality'],
    audioOnly: json['audioOnly'],
    downloadSubtitles: json['downloadSubtitles'],
    status: DownloadStatus.values[json['status']],
    progress: json['progress'],
    errorMessage: json['errorMessage'],
    filePath: json['filePath'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    startedAt: json['startedAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['startedAt']) 
        : null,
    completedAt: json['completedAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(json['completedAt']) 
        : null,
  );
}

class DownloadQueueService extends ChangeNotifier {
  static final DownloadQueueService _instance = DownloadQueueService._internal();
  factory DownloadQueueService() => _instance;
  DownloadQueueService._internal();

  final Queue<DownloadItem> _queue = Queue<DownloadItem>();
  final List<DownloadItem> _activeDownloads = [];
  final List<DownloadItem> _completedDownloads = [];
  final List<DownloadItem> _failedDownloads = [];
  
  int _maxConcurrentDownloads = 2;
  bool _isProcessing = false;

  // Getters
  List<DownloadItem> get queuedItems => _queue.toList();
  List<DownloadItem> get activeDownloads => List.unmodifiable(_activeDownloads);
  List<DownloadItem> get completedDownloads => List.unmodifiable(_completedDownloads);
  List<DownloadItem> get failedDownloads => List.unmodifiable(_failedDownloads);
  List<DownloadItem> get allDownloads => [
    ..._queue,
    ..._activeDownloads,
    ..._completedDownloads,
    ..._failedDownloads,
  ];
  
  int get maxConcurrentDownloads => _maxConcurrentDownloads;
  bool get isProcessing => _isProcessing;
  int get totalQueuedCount => _queue.length;
  int get totalActiveCount => _activeDownloads.length;
  int get totalCompletedCount => _completedDownloads.length;
  int get totalFailedCount => _failedDownloads.length;

  /// Set maximum concurrent downloads
  void setMaxConcurrentDownloads(int max) {
    _maxConcurrentDownloads = max.clamp(1, 5);
    notifyListeners();
    _processQueue();
  }

  /// Add a download to the queue
  Future<String> addDownload({
    required String url,
    required String outputPath,
    required String format,
    required String quality,
    required bool audioOnly,
    required bool downloadSubtitles,
  }) async {
    // Get video info first
    final videoInfo = await EmbeddedYtDlpService.getVideoInfo(url);
    final title = videoInfo['success'] == true 
        ? videoInfo['title'] ?? 'Unknown Video'
        : 'Unknown Video';

    final downloadItem = DownloadItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      url: url,
      title: title,
      outputPath: outputPath,
      format: format,
      quality: quality,
      audioOnly: audioOnly,
      downloadSubtitles: downloadSubtitles,
    );

    _queue.add(downloadItem);
    notifyListeners();
    
    // Start processing if not already processing
    _processQueue();
    
    return downloadItem.id;
  }

  /// Remove a download from queue
  void removeFromQueue(String id) {
    _queue.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// Cancel an active download
  void cancelDownload(String id) {
    final activeItem = _activeDownloads.firstWhere(
      (item) => item.id == id,
      orElse: () => throw ArgumentError('Download not found'),
    );
    
    activeItem.status = DownloadStatus.cancelled;
    activeItem.progress = 'Cancelled';
    
    _activeDownloads.remove(activeItem);
    _failedDownloads.add(activeItem);
    
    notifyListeners();
    _processQueue();
  }

  /// Retry a failed download
  void retryDownload(String id) {
    final failedItem = _failedDownloads.firstWhere(
      (item) => item.id == id,
      orElse: () => throw ArgumentError('Download not found'),
    );
    
    failedItem.status = DownloadStatus.queued;
    failedItem.progress = 'Queued';
    failedItem.errorMessage = null;
    failedItem.startedAt = null;
    failedItem.completedAt = null;
    
    _failedDownloads.remove(failedItem);
    _queue.add(failedItem);
    
    notifyListeners();
    _processQueue();
  }

  /// Clear completed downloads
  void clearCompleted() {
    _completedDownloads.clear();
    notifyListeners();
  }

  /// Clear failed downloads
  void clearFailed() {
    _failedDownloads.clear();
    notifyListeners();
  }

  /// Clear all downloads
  void clearAll() {
    _queue.clear();
    _completedDownloads.clear();
    _failedDownloads.clear();
    // Don't clear active downloads as they're still running
    notifyListeners();
  }

  /// Process the download queue
  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty && _activeDownloads.length < _maxConcurrentDownloads) {
      final item = _queue.removeFirst();
      _activeDownloads.add(item);
      
      item.status = DownloadStatus.downloading;
      item.startedAt = DateTime.now();
      notifyListeners();
      
      // Start download without awaiting (concurrent)
      _downloadItem(item);
    }

    _isProcessing = false;
  }

  /// Download a single item
  Future<void> _downloadItem(DownloadItem item) async {
    try {
      await EmbeddedYtDlpService.downloadVideo(
        url: item.url,
        outputPath: item.outputPath,
        format: item.format,
        quality: item.quality,
        audioOnly: item.audioOnly,
        downloadSubtitles: item.downloadSubtitles,
        onProgress: (progress) {
          item.progress = progress;
          notifyListeners();
        },
        onError: (error) {
          item.status = DownloadStatus.failed;
          item.progress = 'Failed';
          item.errorMessage = error;
          item.completedAt = DateTime.now();
          
          _activeDownloads.remove(item);
          _failedDownloads.add(item);
          notifyListeners();
          
          // Continue processing queue
          _processQueue();
        },
        onComplete: (message) async {
          item.status = DownloadStatus.completed;
          item.progress = 'Completed';
          item.completedAt = DateTime.now();
          
          // Try to find the downloaded file
          await _findDownloadedFile(item);
          
          _activeDownloads.remove(item);
          _completedDownloads.add(item);
          notifyListeners();
          
          // Continue processing queue
          _processQueue();
        },
      );
    } catch (e) {
      item.status = DownloadStatus.failed;
      item.progress = 'Failed';
      item.errorMessage = e.toString();
      item.completedAt = DateTime.now();
      
      _activeDownloads.remove(item);
      _failedDownloads.add(item);
      notifyListeners();
      
      // Continue processing queue
      _processQueue();
    }
  }

  /// Find the downloaded file path
  Future<void> _findDownloadedFile(DownloadItem item) async {
    try {
      final directory = Directory(item.outputPath);
      if (await directory.exists()) {
        final files = await directory.list().toList();
        
        // Find the most recently modified file that matches our criteria
        File? latestFile;
        DateTime? latestTime;
        
        for (final entity in files) {
          if (entity is File) {
            final fileName = entity.path.split(Platform.pathSeparator).last;
            
            // Check if file might be our download (basic heuristic)
            if (fileName.toLowerCase().contains(item.title.toLowerCase().split(' ').first) ||
                fileName.contains(item.id)) {
              final stat = await entity.stat();
              if (latestTime == null || stat.modified.isAfter(latestTime)) {
                latestTime = stat.modified;
                latestFile = entity;
              }
            }
          }
        }
        
        if (latestFile != null) {
          item.filePath = latestFile.path;
        }
      }
    } catch (e) {
      debugPrint('Error finding downloaded file: $e');
    }
  }

  /// Get download by ID
  DownloadItem? getDownload(String id) {
    for (final item in allDownloads) {
      if (item.id == id) return item;
    }
    return null;
  }

  /// Pause all downloads (stop processing new ones)
  void pauseAll() {
    // Note: This doesn't pause active downloads, just stops new ones from starting
    _isProcessing = true;
    notifyListeners();
  }

  /// Resume processing queue
  void resumeAll() {
    _isProcessing = false;
    _processQueue();
  }

  /// Get download statistics
  Map<String, dynamic> getStatistics() {
    final totalDownloads = allDownloads.length;
    final successRate = totalDownloads > 0 
        ? (totalCompletedCount / totalDownloads * 100).toStringAsFixed(1)
        : '0.0';
    
    return {
      'totalDownloads': totalDownloads,
      'queued': totalQueuedCount,
      'active': totalActiveCount,
      'completed': totalCompletedCount,
      'failed': totalFailedCount,
      'successRate': '$successRate%',
      'maxConcurrent': maxConcurrentDownloads,
    };
  }
}
