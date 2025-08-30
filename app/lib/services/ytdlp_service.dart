import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class YtDlpService {
  static String? _ytDlpPath;

  /// Initialize yt-dlp service and check if yt-dlp is available
  static Future<bool> initialize() async {
    try {
      // First, try to find yt-dlp in system PATH
      final result = await Process.run('where', ['yt-dlp'], runInShell: true);
      if (result.exitCode == 0) {
        _ytDlpPath = 'yt-dlp';
        return true;
      }
    } catch (e) {
      debugPrint('yt-dlp not found in system PATH: $e');
    }

    try {
      // Try alternative command for Unix-like systems
      final result = await Process.run('which', ['yt-dlp'], runInShell: true);
      if (result.exitCode == 0) {
        _ytDlpPath = 'yt-dlp';
        return true;
      }
    } catch (e) {
      debugPrint('yt-dlp not found with which command: $e');
    }

    // If not found in PATH, check if we have a bundled version
    final bundledPath = await _getBundledYtDlpPath();
    if (bundledPath != null && await File(bundledPath).exists()) {
      _ytDlpPath = bundledPath;
      return true;
    }

    return false;
  }

  /// Get the path where bundled yt-dlp should be located
  static Future<String?> _getBundledYtDlpPath() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final ytDlpPath = '${appDir.path}/yt-dlp${Platform.isWindows ? '.exe' : ''}';
      return ytDlpPath;
    } catch (e) {
      return null;
    }
  }

  /// Check if yt-dlp is available
  static Future<bool> isAvailable() async {
    if (_ytDlpPath == null) {
      return await initialize();
    }
    return true;
  }

  /// Get video information without downloading
  static Future<Map<String, dynamic>> getVideoInfo(String url) async {
    if (!await isAvailable()) {
      throw Exception('yt-dlp is not available. Please install yt-dlp first.');
    }

    try {
      final result = await Process.run(
        _ytDlpPath!,
        [
          '--dump-json',
          '--no-playlist',
          url,
        ],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        final jsonOutput = result.stdout.toString().trim();
        final lines = jsonOutput.split('\n');
        // Get the last non-empty line (should be the JSON)
        final jsonLine = lines.lastWhere((line) => line.trim().isNotEmpty);
        final videoInfo = jsonDecode(jsonLine);
        
        return {
          'success': true,
          'title': videoInfo['title'] ?? 'Unknown Title',
          'duration': videoInfo['duration'] ?? 0,
          'uploader': videoInfo['uploader'] ?? 'Unknown',
          'view_count': videoInfo['view_count'] ?? 0,
          'formats': videoInfo['formats'] ?? [],
        };
      } else {
        return {
          'success': false,
          'error': result.stderr.toString(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Download video with progress tracking
  static Future<void> downloadVideo({
    required String url,
    required String outputPath,
    required String format,
    required String quality,
    required bool audioOnly,
    required bool downloadSubtitles,
    required Function(String) onProgress,
    required Function(String) onError,
    required Function(String) onComplete,
  }) async {
    if (!await isAvailable()) {
      onError('yt-dlp is not available. Please install yt-dlp first.');
      return;
    }

    try {
      // Build yt-dlp command arguments
      final args = <String>[
        '--newline',  // Ensure each progress update is on a new line
        '--progress', // Show progress
        '-o', '$outputPath/%(title)s.%(ext)s', // Output template
      ];

      // Add format selection
      if (audioOnly) {
        args.addAll(['-f', 'bestaudio', '--extract-audio', '--audio-format', 'mp3']);
      } else {
        if (quality != 'best') {
          args.addAll(['-f', 'best[height<=${quality.replaceAll('p', '')}]']);
        } else if (format != 'best') {
          args.addAll(['-f', 'best[ext=$format]']);
        }
      }

      // Add subtitle download if requested
      if (downloadSubtitles) {
        args.addAll(['--write-subs', '--write-auto-subs', '--sub-lang', 'en']);
      }

      // Add the URL
      args.add(url);

      onProgress('Starting download...');

      // Start the process
      final process = await Process.start(
        _ytDlpPath!,
        args,
        runInShell: true,
        workingDirectory: outputPath,
      );

      // Listen to stdout for progress updates
      process.stdout.transform(utf8.decoder).listen((data) {
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.trim().isNotEmpty) {
            _parseProgressLine(line, onProgress);
          }
        }
      });

      // Listen to stderr for errors
      process.stderr.transform(utf8.decoder).listen((data) {
        if (data.trim().isNotEmpty) {
          debugPrint('yt-dlp stderr: $data');
          // Don't treat all stderr as errors, as yt-dlp outputs info there too
        }
      });

      // Wait for the process to complete
      final exitCode = await process.exitCode;

      if (exitCode == 0) {
        onComplete('Download completed successfully!');
      } else {
        onError('Download failed with exit code: $exitCode');
      }
    } catch (e) {
      onError('Download error: ${e.toString()}');
    }
  }

  /// Parse progress line from yt-dlp output
  static void _parseProgressLine(String line, Function(String) onProgress) {
    // yt-dlp progress format: [download]  45.2% of 123.45MiB at 1.23MiB/s ETA 00:30
    if (line.contains('[download]')) {
      if (line.contains('%')) {
        // Extract percentage and other info
        final percentMatch = RegExp(r'(\d+\.?\d*)%').firstMatch(line);
        final sizeMatch = RegExp(r'of\s+([\d.]+\w+)').firstMatch(line);
        final speedMatch = RegExp(r'at\s+([\d.]+\w+/s)').firstMatch(line);
        final etaMatch = RegExp(r'ETA\s+(\d+:\d+)').firstMatch(line);

        String progressText = 'Downloading';
        if (percentMatch != null) {
          progressText += ' ${percentMatch.group(1)}%';
        }
        if (sizeMatch != null) {
          progressText += ' of ${sizeMatch.group(1)}';
        }
        if (speedMatch != null) {
          progressText += ' at ${speedMatch.group(1)}';
        }
        if (etaMatch != null) {
          progressText += ' (ETA: ${etaMatch.group(1)})';
        }

        onProgress(progressText);
      } else if (line.contains('Destination:')) {
        onProgress('Preparing download...');
      } else if (line.contains('has already been downloaded')) {
        onProgress('File already exists');
      }
    } else if (line.contains('[info]')) {
      if (line.contains('Extracting URL')) {
        onProgress('Extracting video information...');
      } else if (line.contains('Downloading webpage')) {
        onProgress('Fetching video details...');
      }
    } else if (line.contains('[ExtractAudio]')) {
      onProgress('Extracting audio...');
    } else if (line.contains('[ffmpeg]')) {
      onProgress('Processing video...');
    }
  }

  /// Get available formats for a video
  static Future<List<Map<String, dynamic>>> getAvailableFormats(String url) async {
    if (!await isAvailable()) {
      return [];
    }

    try {
      final result = await Process.run(
        _ytDlpPath!,
        [
          '--list-formats',
          '--no-playlist',
          url,
        ],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        // Parse format list (this is a simplified version)
        final lines = result.stdout.toString().split('\n');
        final formats = <Map<String, dynamic>>[];
        
        for (final line in lines) {
          if (line.contains('mp4') || line.contains('webm') || line.contains('mkv')) {
            // This is a simplified parser - in a real implementation,
            // you'd want more robust parsing
            formats.add({
              'format_id': line.split(' ')[0],
              'ext': line.contains('mp4') ? 'mp4' : 
                     line.contains('webm') ? 'webm' : 'mkv',
              'quality': line,
            });
          }
        }
        
        return formats;
      }
    } catch (e) {
      debugPrint('Error getting formats: $e');
    }

    return [];
  }

  /// Check if a URL is supported by yt-dlp
  static Future<bool> isUrlSupported(String url) async {
    if (!await isAvailable()) {
      return false;
    }

    try {
      final result = await Process.run(
        _ytDlpPath!,
        [
          '--simulate',
          '--quiet',
          url,
        ],
        runInShell: true,
      );

      return result.exitCode == 0;
    } catch (e) {
      return false;
    }
  }

  /// Get yt-dlp version
  static Future<String?> getVersion() async {
    if (!await isAvailable()) {
      return null;
    }

    try {
      final result = await Process.run(
        _ytDlpPath!,
        ['--version'],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        return result.stdout.toString().trim();
      }
    } catch (e) {
      debugPrint('Error getting yt-dlp version: $e');
    }

    return null;
  }

  /// Download and install yt-dlp (for platforms that support it)
  static Future<bool> downloadAndInstallYtDlp() async {
    try {
      // This is a placeholder - in a real implementation, you'd download
      // the yt-dlp binary from GitHub releases
      onProgress('This feature is not yet implemented. Please install yt-dlp manually.');
      
      return false;
    } catch (e) {
      return false;
    }
  }

  static void onProgress(String message) {
    debugPrint('YtDlp: $message');
  }
}
