import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../components/ytdlp_version_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../constants.dart';
import '../types.dart';

/// Compact download section for desktop layout
class CompactDownloadSection extends StatelessWidget {
  final TextEditingController urlController;
  final TextEditingController pathController;
  final DownloadOptions options;
  final bool isDownloading;
  final bool isEnabled;
  final VoidCallback onPasteFromClipboard;
  final VoidCallback onSelectFolder;
  final VoidCallback onOpenFolder;
  final VoidCallback onDownload;
  final ValueChanged<DownloadOptions> onOptionsChanged;
  final ValueChanged<String>? onUrlChanged;
  
  const CompactDownloadSection({
    super.key,
    required this.urlController,
    required this.pathController,
    required this.options,
    required this.isDownloading,
    required this.isEnabled,
    required this.onPasteFromClipboard,
    required this.onSelectFolder,
    required this.onOpenFolder,
    required this.onDownload,
    required this.onOptionsChanged,
    this.onUrlChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    final l10n = AppLocalizations.of(context)!;
    
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
            // Header with version badge
            Row(
              children: [
                Text(
                  l10n.downloadVideo,
                  style: AppTextStyles.cardTitle(locale),
                ),
                const Spacer(),
                const YtDlpVersionBadge(),
              ],
            ),
            const SizedBox(height: 20),
            
            // URL input
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      labelText: l10n.youtubeUrl,
                      hintText: 'https://www.youtube.com/watch?v=...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.link),
                      suffixIcon: IconButton(
                        onPressed: onPasteFromClipboard,
                        icon: const Icon(Icons.paste),
                        tooltip: l10n.pasteFromClipboard,
                      ),
                    ),
                    style: AppTextStyles.bodyText(locale),
                    onChanged: onUrlChanged,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Compact options
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: options.quality,
                          decoration: InputDecoration(
                            labelText: l10n.quality,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          style: AppTextStyles.bodyText(locale),
                          items: DownloaderConstants.qualities.map((quality) {
                            return DropdownMenuItem<String>(
                              value: quality,
                              child: Text(quality),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              onOptionsChanged(options.copyWith(quality: value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: options.format,
                          decoration: InputDecoration(
                            labelText: l10n.format,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          style: AppTextStyles.bodyText(locale),
                          items: DownloaderConstants.formats.map((format) {
                            return DropdownMenuItem<String>(
                              value: format,
                              child: Text(format.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              onOptionsChanged(options.copyWith(format: value));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Path and options row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: pathController,
                    decoration: InputDecoration(
                      labelText: l10n.downloadPath,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.folder),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: onOpenFolder,
                            icon: const Icon(Icons.folder_open),
                            tooltip: l10n.openFolder,
                          ),
                          IconButton(
                            onPressed: onSelectFolder,
                            icon: const Icon(Icons.edit),
                            tooltip: l10n.selectFolder,
                          ),
                        ],
                      ),
                    ),
                    style: AppTextStyles.bodyText(locale),
                    readOnly: true,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Compact toggle buttons and download button
                Row(
                  children: [
                    _buildToggleButton(
                      label: l10n.audioOnly,
                      icon: Icons.headphones,
                      isSelected: options.audioOnly,
                      onTap: () {
                        onOptionsChanged(options.copyWith(audioOnly: !options.audioOnly));
                      },
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 8),
                    _buildToggleButton(
                      label: l10n.subtitles,
                      icon: Icons.subtitles,
                      isSelected: options.downloadSubtitles,
                      onTap: () {
                        onOptionsChanged(options.copyWith(downloadSubtitles: !options.downloadSubtitles));
                      },
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    
                    // Download button - aligned with toggles
                    SizedBox(
                      width: 140, // Increased width to fit text properly
                      height: 40, // Match toggle button height
                      child: ElevatedButton.icon(
                        onPressed: (isDownloading || !isEnabled) ? null : onDownload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        icon: isDownloading
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.download, size: 16),
                        label: Text(
                          isDownloading ? l10n.adding : l10n.download,
                          style: AppTextStyles.buttonText(locale).copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
              ? color.withValues(alpha: 0.15)
              : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                ? color.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? color : Colors.grey.shade600,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
