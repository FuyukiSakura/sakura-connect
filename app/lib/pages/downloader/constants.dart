/// Constants for the downloader functionality
class DownloaderConstants {
  // Available video formats
  static const List<String> formats = ['best', 'mp4', 'webm', 'mkv'];
  
  // Available video qualities
  static const List<String> qualities = ['best', '1080p', '720p', '480p', '360p'];
  
  // Default values
  static const String defaultFormat = 'best';
  static const String defaultQuality = 'best';
  
  // URL validation patterns
  static const List<String> validYouTubePatterns = [
    'youtube.com/watch',
    'youtu.be/',
    'youtube.com/playlist',
    'youtube.com/shorts',
  ];
  
  // Status messages
  static const String startingDownloadMessage = 'Starting download...';
  static const String ytDlpUnavailableMessage = 'Embedded yt-dlp is not available. Please check your internet connection and restart the app.';
  static const String setupRequiredMessage = 'Please go to the "yt-dlp Setup" tab to install yt-dlp.';
}
