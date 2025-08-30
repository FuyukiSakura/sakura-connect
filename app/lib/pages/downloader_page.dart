import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../components/compact_queue_status.dart';
import '../components/desktop_layout.dart';
import '../services/download_queue_service.dart';
import 'downloader/hooks/use_download_management.dart';
import 'downloader/hooks/use_path_management.dart';
import 'downloader/hooks/use_url_management.dart';
import 'downloader/components/compact_download_section.dart';
import 'downloader/components/download_options_section.dart';
import 'downloader/components/url_input_section.dart';
import 'downloader/components/path_input_section.dart';
import 'downloader/components/download_button.dart';
import 'downloader/components/setup_required_section.dart';
import 'downloader/components/download_status_section.dart';
import 'downloader/utils.dart';

class DownloaderPage extends StatefulWidget {
  const DownloaderPage({super.key});

  @override
  State<DownloaderPage> createState() => _DownloaderPageState();
}

class _DownloaderPageState extends State<DownloaderPage> {
  late UseDownloadManagement _downloadManagement;
  late UsePathManagement _pathManagement;
  late UseUrlManagement _urlManagement;

  @override
  void initState() {
    super.initState();
    _downloadManagement = UseDownloadManagement();
    _pathManagement = UsePathManagement();
    _urlManagement = UseUrlManagement();
  }

  @override
  void dispose() {
    _downloadManagement.dispose();
    _pathManagement.dispose();
    _urlManagement.dispose();
    super.dispose();
  }

  void _handleDownload() async {
    await _downloadManagement.downloadVideo(
      context: context,
      url: _urlManagement.url,
      outputPath: _pathManagement.outputPathController.text,
    );
    
    // Clear URL after successful download initiation
    if (!_downloadManagement.state.status.contains('Failed')) {
      _urlManagement.clearUrl();
    }
  }
  
  void _handleGoToSetup() {
    DownloaderUtils.showErrorSnackBar(context, 'Please go to the "yt-dlp Setup" tab to install yt-dlp.');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _downloadManagement),
        ChangeNotifierProvider.value(value: _pathManagement),
        ChangeNotifierProvider.value(value: _urlManagement),
      ],
      child: Consumer3<UseDownloadManagement, UsePathManagement, UseUrlManagement>(
        builder: (context, downloadMgmt, pathMgmt, urlMgmt, child) {
          if (isDesktop) {
            return _buildDesktopLayout(downloadMgmt, pathMgmt, urlMgmt);
          } else {
            return _buildMobileLayout(downloadMgmt, pathMgmt, urlMgmt);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(
    UseDownloadManagement downloadMgmt,
    UsePathManagement pathMgmt,
    UseUrlManagement urlMgmt,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact header with queue status
          Row(
            children: [
              Expanded(
                child: Text(
                  'YouTube Downloader',
                  style: AppTextStyles.heroTitle().copyWith(
                    fontSize: 28,
                    color: AppColors.primary,
                  ),
                ),
              ),
              CompactQueueStatus(
                onTap: () => context.showDesktopQueue(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          if (!downloadMgmt.state.ytDlpAvailable) ...[
            SetupRequiredSection(
              onGoToSetup: _handleGoToSetup,
            ),
            const SizedBox(height: 24),
          ],
          
          // Main download section - compact
          CompactDownloadSection(
            urlController: urlMgmt.urlController,
            pathController: pathMgmt.outputPathController,
            options: downloadMgmt.options,
            isDownloading: downloadMgmt.state.isDownloading,
            isEnabled: downloadMgmt.state.ytDlpAvailable && urlMgmt.hasValidUrl,
            onPasteFromClipboard: () => urlMgmt.pasteFromClipboard(context),
            onSelectFolder: () => pathMgmt.selectDownloadFolder(context),
            onOpenFolder: () => pathMgmt.openDownloadFolder(context),
            onDownload: _handleDownload,
            onOptionsChanged: downloadMgmt.updateOptions,
            onUrlChanged: (_) {}, // URL changes are handled by the controller
          ),
          
          if (downloadMgmt.state.status.isNotEmpty) ...[
            const SizedBox(height: 16),
            DownloadStatusSection(
              status: downloadMgmt.state.status,
              isDownloading: downloadMgmt.state.isDownloading,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
    UseDownloadManagement downloadMgmt,
    UsePathManagement pathMgmt,
    UseUrlManagement urlMgmt,
  ) {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!downloadMgmt.state.ytDlpAvailable) ...[
            SetupRequiredSection(
              onGoToSetup: _handleGoToSetup,
            ),
            const SizedBox(height: 24),
          ],
          
          // URL Input Section
          Card(
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
                    l10n.youtubeVideoDownloader,
                    style: AppTextStyles.cardTitle(Provider.of<LocaleProvider>(context).locale),
                  ),
                  const SizedBox(height: 16),
                  UrlInputSection(
                    controller: urlMgmt.urlController,
                    onPasteFromClipboard: () => urlMgmt.pasteFromClipboard(context),
                  ),
                  const SizedBox(height: 16),
                  PathInputSection(
                    controller: pathMgmt.outputPathController,
                    onSelectFolder: () => pathMgmt.selectDownloadFolder(context),
                    onOpenFolder: () => pathMgmt.openDownloadFolder(context),
                  ),
                  const SizedBox(height: 16),
                  DownloadButton(
                    onPressed: _handleDownload,
                    isDownloading: downloadMgmt.state.isDownloading,
                    isEnabled: downloadMgmt.state.ytDlpAvailable && urlMgmt.hasValidUrl,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Download Options
          DownloadOptionsSection(
            options: downloadMgmt.options,
            onOptionsChanged: downloadMgmt.updateOptions,
          ),
          const SizedBox(height: 24),
          
          // Path Info Section
          _buildPathInfoSection(pathMgmt),
          const SizedBox(height: 24),
          
          // Queue Summary
          _buildQueueSummarySection(downloadMgmt),
          
          if (downloadMgmt.state.status.isNotEmpty) ...[
            const SizedBox(height: 24),
            DownloadStatusSection(
              status: downloadMgmt.state.status,
              isDownloading: downloadMgmt.state.isDownloading,
            ),
          ],
        ],
      ),
    );
  }





  // Helper methods for mobile layout
  Widget _buildPathInfoSection(UsePathManagement pathMgmt) {
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
        padding: const EdgeInsets.all(16.0),
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
                  'Download Information',
                  style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Files will be saved to:', pathMgmt.effectiveDownloadPath.isEmpty ? 'Loading...' : pathMgmt.effectiveDownloadPath, locale),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Locale? locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText(locale).copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.darkGray,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundGray,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.borderGray.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            value,
            style: AppTextStyles.bodyText(locale).copyWith(
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQueueSummarySection(UseDownloadManagement downloadMgmt) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return ChangeNotifierProvider.value(
      value: downloadMgmt.queueService,
      child: Consumer<DownloadQueueService>(
        builder: (context, queueService, child) {
          final stats = queueService.getStatistics();
          
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.queue_play_next,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Download Queue Summary',
                        style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQueueStatItem('Queued', stats['queued'].toString(), Colors.orange),
                      _buildQueueStatItem('Active', stats['active'].toString(), Colors.blue),
                      _buildQueueStatItem('Completed', stats['completed'].toString(), Colors.green),
                      _buildQueueStatItem('Failed', stats['failed'].toString(), Colors.red),
                    ],
                  ),
                  if (stats['totalDownloads'] > 0) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Success Rate: ${stats['successRate']} | Max Concurrent: ${stats['maxConcurrent']}',
                      style: AppTextStyles.bodyText(locale).copyWith(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQueueStatItem(String label, String value, Color color) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heroTitle(locale).copyWith(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodyText(locale).copyWith(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

}
