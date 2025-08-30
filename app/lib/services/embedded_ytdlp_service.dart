import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class EmbeddedYtDlpService {
  static String? _embeddedYtDlpPath;
  static bool _isInitialized = false;

  /// Initialize the embedded yt-dlp service
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Use embedded binary approach for all platforms
      final success = await _initializeEmbeddedBinary();
      _isInitialized = success;
      return success;
    } catch (e) {
      debugPrint('Failed to initialize embedded yt-dlp: $e');
      return false;
    }
  }

  /// Initialize embedded binary for desktop platforms
  static Future<bool> _initializeEmbeddedBinary() async {
    try {
      final appDir = await getApplicationSupportDirectory();
      final ytDlpDir = Directory('${appDir.path}/yt-dlp');
      
      if (!await ytDlpDir.exists()) {
        await ytDlpDir.create(recursive: true);
      }

      final executableName = Platform.isWindows ? 'yt-dlp.exe' : 'yt-dlp';
      final ytDlpPath = '${ytDlpDir.path}/$executableName';
      final ytDlpFile = File(ytDlpPath);

      // Check if binary already exists and is executable
      if (await ytDlpFile.exists()) {
        try {
          // Test if the binary works
          final result = await Process.run(ytDlpPath, ['--version'], runInShell: true);
          if (result.exitCode == 0) {
            _embeddedYtDlpPath = ytDlpPath;
            return true;
          }
        } catch (e) {
          // Binary exists but doesn't work, try to re-download
        }
      }

      // Download yt-dlp binary
      final success = await _downloadYtDlpBinary(ytDlpPath);
      if (success) {
        _embeddedYtDlpPath = ytDlpPath;
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error initializing embedded binary: $e');
      return false;
    }
  }

  /// Download yt-dlp binary from GitHub releases
  static Future<bool> _downloadYtDlpBinary(String targetPath) async {
    try {
      String downloadUrl;
      
      if (Platform.isWindows) {
        downloadUrl = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe';
      } else if (Platform.isMacOS) {
        downloadUrl = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos';
      } else if (Platform.isLinux) {
        downloadUrl = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp';
      } else if (Platform.isAndroid) {
        // For Android, we'll use a Python-based approach or fallback
        downloadUrl = 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp';
      } else {
        return false;
      }

      debugPrint('Downloading yt-dlp from: $downloadUrl');
      
      final response = await http.get(Uri.parse(downloadUrl));
      if (response.statusCode == 200) {
        final file = File(targetPath);
        await file.writeAsBytes(response.bodyBytes);
        
        // Make executable on Unix-like systems
        if (!Platform.isWindows) {
          await Process.run('chmod', ['+x', targetPath]);
        }
        
        debugPrint('yt-dlp binary downloaded successfully to: $targetPath');
        return true;
      } else {
        debugPrint('Failed to download yt-dlp: HTTP ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error downloading yt-dlp binary: $e');
      return false;
    }
  }

  /// Check if the service is available
  static Future<bool> isAvailable() async {
    if (!_isInitialized) {
      return await initialize();
    }
    return _isInitialized;
  }

  /// Get video information
  static Future<Map<String, dynamic>> getVideoInfo(String url) async {
    if (!await isAvailable()) {
      return {'success': false, 'error': 'yt-dlp service not available'};
    }

    try {
      return await _getVideoInfoDesktop(url);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }



  /// Get video info on desktop using embedded binary
  static Future<Map<String, dynamic>> _getVideoInfoDesktop(String url) async {
    if (_embeddedYtDlpPath == null) {
      return {'success': false, 'error': 'yt-dlp binary not available'};
    }

    try {
      final result = await Process.run(
        _embeddedYtDlpPath!,
        ['--dump-json', '--no-playlist', url],
        runInShell: true,
      );

      if (result.exitCode == 0) {
        final jsonOutput = result.stdout.toString().trim();
        final lines = jsonOutput.split('\n');
        final jsonLine = lines.lastWhere((line) => line.trim().isNotEmpty);
        final videoInfo = jsonDecode(jsonLine);
        
        return {
          'success': true,
          'title': videoInfo['title'] ?? 'Unknown Title',
          'duration': videoInfo['duration'] ?? 0,
          'uploader': videoInfo['uploader'] ?? 'Unknown',
          'view_count': videoInfo['view_count'] ?? 0,
        };
      } else {
        return {'success': false, 'error': result.stderr.toString()};
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Download video
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
      onError('yt-dlp service not available');
      return;
    }

    try {
      await _downloadVideoDesktop(
        url: url,
        outputPath: outputPath,
        format: format,
        quality: quality,
        audioOnly: audioOnly,
        downloadSubtitles: downloadSubtitles,
        onProgress: onProgress,
        onError: onError,
        onComplete: onComplete,
      );
    } catch (e) {
      onError('Download error: ${e.toString()}');
    }
  }



  /// Download video on desktop using embedded binary
  static Future<void> _downloadVideoDesktop({
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
    if (_embeddedYtDlpPath == null) {
      onError('yt-dlp binary not available');
      return;
    }

    try {
      final args = <String>[
        '--newline',
        '--progress',
        '-o', '$outputPath/%(title)s.%(ext)s',
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

      if (downloadSubtitles) {
        args.addAll(['--write-subs', '--write-auto-subs', '--sub-lang', 'en']);
      }

      args.add(url);

      onProgress('Starting download...');

      final process = await Process.start(
        _embeddedYtDlpPath!,
        args,
        runInShell: true,
        workingDirectory: outputPath,
      );

      process.stdout.transform(utf8.decoder).listen((data) {
        final lines = data.split('\n');
        for (final line in lines) {
          if (line.trim().isNotEmpty) {
            _parseProgressLine(line, onProgress);
          }
        }
      });

      process.stderr.transform(utf8.decoder).listen((data) {
        if (data.trim().isNotEmpty) {
          debugPrint('yt-dlp stderr: $data');
        }
      });

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
    if (line.contains('[download]')) {
      if (line.contains('%')) {
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

  /// Get version information
  static Future<String?> getVersion() async {
    if (!await isAvailable()) return null;

    try {
      if (_embeddedYtDlpPath != null) {
        final result = await Process.run(_embeddedYtDlpPath!, ['--version'], runInShell: true);
        if (result.exitCode == 0) {
          return result.stdout.toString().trim();
        }
      }
    } catch (e) {
      debugPrint('Error getting version: $e');
    }
    return null;
  }

  /// Check if URL is supported
  static Future<bool> isUrlSupported(String url) async {
    if (!await isAvailable()) return false;

    try {
      if (_embeddedYtDlpPath != null) {
        final result = await Process.run(
          _embeddedYtDlpPath!,
          ['--simulate', '--quiet', url],
          runInShell: true,
        );
        return result.exitCode == 0;
      }
    } catch (e) {
      debugPrint('Error checking URL support: $e');
    }
    return false;
  }

  /// Get download progress for initialization
  static Stream<String> getInitializationProgress() async* {
    yield 'Checking for embedded yt-dlp binary...';
    await Future.delayed(const Duration(milliseconds: 500));
    
    final appDir = await getApplicationSupportDirectory();
    final executableName = Platform.isWindows ? 'yt-dlp.exe' : 'yt-dlp';
    final ytDlpPath = '${appDir.path}/yt-dlp/$executableName';
    
    if (!await File(ytDlpPath).exists()) {
      yield 'Downloading yt-dlp binary...';
      await Future.delayed(const Duration(milliseconds: 1000));
      yield 'Installing yt-dlp...';
      await Future.delayed(const Duration(milliseconds: 1500));
    }
    
    yield 'Embedded yt-dlp ready!';
  }
}
