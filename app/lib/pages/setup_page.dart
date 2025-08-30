import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/embedded_ytdlp_service.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  bool _isInitializing = false;
  bool _ytDlpAvailable = false;
  String _ytDlpStatus = '';
  String? _currentVersion;
  List<String> _availableVersions = [];
  bool _loadingVersions = false;
  String? _selectedVersion;

  @override
  void initState() {
    super.initState();
    _checkYtDlpStatus();
    _loadAvailableVersions();
  }

  Future<void> _checkYtDlpStatus() async {
    final isAvailable = await EmbeddedYtDlpService.isAvailable();
    final version = await EmbeddedYtDlpService.getVersion();
    
    setState(() {
      _ytDlpAvailable = isAvailable;
      _currentVersion = version;
      if (isAvailable) {
        _ytDlpStatus = version != null ? 'yt-dlp v$version installed' : 'yt-dlp installed';
      } else {
        _ytDlpStatus = 'yt-dlp not installed';
      }
    });
  }

  Future<void> _loadAvailableVersions() async {
    setState(() {
      _loadingVersions = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/yt-dlp/yt-dlp/releases'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> releases = jsonDecode(response.body);
        final versions = releases
            .where((release) => !release['prerelease'])
            .take(10) // Get last 10 stable releases
            .map<String>((release) => release['tag_name'].toString())
            .toList();
        
        setState(() {
          _availableVersions = versions;
          _selectedVersion = versions.isNotEmpty ? versions.first : null;
        });
      }
    } catch (e) {
      debugPrint('Error loading versions: $e');
    } finally {
      setState(() {
        _loadingVersions = false;
      });
    }
  }

  Future<void> _initializeYtDlp() async {
    setState(() {
      _isInitializing = true;
      _ytDlpStatus = 'Initializing yt-dlp...';
    });

    try {
      // Listen to initialization progress
      await for (final progress in EmbeddedYtDlpService.getInitializationProgress()) {
        setState(() {
          _ytDlpStatus = progress;
        });
      }

      final success = await EmbeddedYtDlpService.initialize();
      
      if (success) {
        await _checkYtDlpStatus();
        _showSuccessSnackBar('yt-dlp initialized successfully!');
      } else {
        setState(() {
          _ytDlpStatus = 'Failed to initialize yt-dlp';
        });
        _showErrorSnackBar('Failed to initialize yt-dlp. Check your internet connection.');
      }
    } catch (e) {
      setState(() {
        _ytDlpStatus = 'Error: ${e.toString()}';
      });
      _showErrorSnackBar('Error initializing yt-dlp: ${e.toString()}');
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _deleteYtDlp() async {
    final confirmed = await _showDeleteConfirmDialog();
    if (!confirmed) return;

    try {
      // Delete the yt-dlp binary and directory
      final appDir = await getApplicationSupportDirectory();
      final ytDlpDir = Directory('${appDir.path}/yt-dlp');
      
      if (await ytDlpDir.exists()) {
        await ytDlpDir.delete(recursive: true);
        await _checkYtDlpStatus();
        _showSuccessSnackBar('yt-dlp deleted successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Error deleting yt-dlp: ${e.toString()}');
    }
  }

  Future<bool> _showDeleteConfirmDialog() async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteYtdlpConfirmTitle),
        content: Text(
          l10n.deleteYtdlpConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusSection(l10n),
          const SizedBox(height: 24),
          _buildActionsSection(l10n),
          const SizedBox(height: 24),
          _buildVersionManagementSection(l10n),
          const SizedBox(height: 24),
          _buildInfoSection(l10n),
        ],
      ),
    );
  }

  Widget _buildStatusSection(AppLocalizations l10n) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      elevation: 2,
      shadowColor: AppColors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _ytDlpAvailable 
            ? Colors.green.withValues(alpha: 0.3)
            : Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _ytDlpAvailable ? Icons.check_circle : Icons.warning,
                  color: _ytDlpAvailable ? Colors.green : Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'yt-dlp Status',
                  style: AppTextStyles.cardTitle(locale),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _ytDlpAvailable 
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _ytDlpAvailable 
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.orange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _ytDlpStatus,
                    style: AppTextStyles.bodyText(locale).copyWith(
                      fontWeight: FontWeight.w600,
                      color: _ytDlpAvailable ? Colors.green.shade700 : Colors.orange.shade700,
                    ),
                  ),
                  if (_currentVersion != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.currentVersion}: $_currentVersion',
                      style: AppTextStyles.bodyText(locale).copyWith(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  if (_isInitializing) ...[
                    const SizedBox(height: 12),
                    const LinearProgressIndicator(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(AppLocalizations l10n) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      elevation: 2,
      shadowColor: AppColors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.borderGray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.actions,
              style: AppTextStyles.cardTitle(locale),
            ),
            const SizedBox(height: 16),
            if (!_ytDlpAvailable) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isInitializing ? null : _initializeYtDlp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: _isInitializing 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.download),
                  label: Text(
                    _isInitializing ? l10n.installing : l10n.installYtdlp,
                    style: AppTextStyles.buttonText(locale),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isInitializing ? null : _initializeYtDlp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: _isInitializing 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.refresh),
                      label: Text(
                        _isInitializing ? l10n.updating : l10n.update,
                        style: AppTextStyles.buttonText(locale),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isInitializing ? null : _deleteYtDlp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.delete),
                      label: Text(
                        l10n.delete,
                        style: AppTextStyles.buttonText(locale),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVersionManagementSection(AppLocalizations l10n) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      elevation: 2,
      shadowColor: AppColors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.borderGray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.versionManagement,
              style: AppTextStyles.cardTitle(locale),
            ),
            const SizedBox(height: 16),
            if (_loadingVersions) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Loading available versions...',
                  style: AppTextStyles.bodyText(locale),
                ),
              ),
            ] else if (_availableVersions.isNotEmpty) ...[
              Text(
                'Available Versions:',
                style: AppTextStyles.bodyText(locale).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedVersion,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.borderGray,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                ),
                style: AppTextStyles.bodyText(locale),
                items: _availableVersions.map((version) {
                  return DropdownMenuItem<String>(
                    value: version,
                    child: Row(
                      children: [
                        Text(version),
                        if (version == _currentVersion) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Current',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVersion = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (_selectedVersion == null || _selectedVersion == _currentVersion || _isInitializing) 
                    ? null 
                    : () => _installSpecificVersion(_selectedVersion!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.download, size: 18),
                  label: Text(
                    'Install Selected Version',
                    style: AppTextStyles.buttonText(locale).copyWith(fontSize: 14),
                  ),
                ),
              ),
            ] else ...[
              Text(
                'Unable to load available versions. Check your internet connection.',
                style: AppTextStyles.bodyText(locale).copyWith(
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: _loadAvailableVersions,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(AppLocalizations l10n) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      elevation: 1,
      shadowColor: AppColors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.borderGray.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'About yt-dlp',
                  style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'yt-dlp is a powerful command-line program to download videos from YouTube and other sites. '
              'This app automatically downloads and manages the yt-dlp binary for you.',
              style: AppTextStyles.bodyText(locale),
            ),
            const SizedBox(height: 12),
            Text(
              'Features:',
              style: AppTextStyles.bodyText(locale).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...[
              '• Download videos in various formats and qualities',
              '• Extract audio-only files',
              '• Download subtitles and metadata',
              '• Support for 1000+ websites',
              '• Regular updates with new features',
            ].map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                feature,
                style: AppTextStyles.bodyText(locale),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _installSpecificVersion(String version) async {
    // This would require implementing version-specific download logic
    // For now, we'll just show a message
    _showErrorSnackBar('Specific version installation not yet implemented. Using latest version.');
    await _initializeYtDlp();
  }
}
