/// Types and data classes for the downloader functionality

/// Download options configuration
class DownloadOptions {
  final String format;
  final String quality;
  final bool audioOnly;
  final bool downloadSubtitles;
  
  const DownloadOptions({
    required this.format,
    required this.quality,
    required this.audioOnly,
    required this.downloadSubtitles,
  });
  
  DownloadOptions copyWith({
    String? format,
    String? quality,
    bool? audioOnly,
    bool? downloadSubtitles,
  }) {
    return DownloadOptions(
      format: format ?? this.format,
      quality: quality ?? this.quality,
      audioOnly: audioOnly ?? this.audioOnly,
      downloadSubtitles: downloadSubtitles ?? this.downloadSubtitles,
    );
  }
}

/// Download state information
class DownloadState {
  final bool isDownloading;
  final String status;
  final String effectiveDownloadPath;
  final String downloadedFilePath;
  final bool ytDlpAvailable;
  
  const DownloadState({
    required this.isDownloading,
    required this.status,
    required this.effectiveDownloadPath,
    required this.downloadedFilePath,
    required this.ytDlpAvailable,
  });
  
  DownloadState copyWith({
    bool? isDownloading,
    String? status,
    String? effectiveDownloadPath,
    String? downloadedFilePath,
    bool? ytDlpAvailable,
  }) {
    return DownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      status: status ?? this.status,
      effectiveDownloadPath: effectiveDownloadPath ?? this.effectiveDownloadPath,
      downloadedFilePath: downloadedFilePath ?? this.downloadedFilePath,
      ytDlpAvailable: ytDlpAvailable ?? this.ytDlpAvailable,
    );
  }
}
