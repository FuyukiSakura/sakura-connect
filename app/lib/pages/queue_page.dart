import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/download_queue_service.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage> with TickerProviderStateMixin {
  late TabController _tabController;
  late DownloadQueueService _queueService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _queueService = DownloadQueueService();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return ChangeNotifierProvider.value(
      value: _queueService,
      child: Column(
        children: [
          _buildHeader(l10n),
          _buildTabBar(l10n),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQueuedTab(l10n),
                _buildActiveTab(l10n),
                _buildCompletedTab(l10n),
                _buildFailedTab(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.queue_play_next,
                size: 28,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.downloadQueue,
                  style: AppTextStyles.heroTitle(locale).copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildSettingsButton(),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.settings, color: AppColors.primary),
      onSelected: (value) {
        switch (value) {
          case 'clear_completed':
            _queueService.clearCompleted();
            break;
          case 'clear_failed':
            _queueService.clearFailed();
            break;
          case 'clear_all':
            _showClearAllDialog(context);
            break;
        }
      },
      itemBuilder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return [
          PopupMenuItem(
            value: 'clear_completed',
            child: Row(
              children: [
                const Icon(Icons.clear_all, color: Colors.green),
                const SizedBox(width: 8),
                Text(l10n.clearCompleted),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'clear_failed',
            child: Row(
              children: [
                const Icon(Icons.clear_all, color: Colors.red),
                const SizedBox(width: 8),
                Text(l10n.clearFailed),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'clear_all',
            child: Row(
              children: [
                const Icon(Icons.delete_sweep, color: Colors.red),
                const SizedBox(width: 8),
                Text(l10n.clearAll),
              ],
            ),
          ),
        ];
      },
    );
  }

  Widget _buildStatistics() {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        final l10n = AppLocalizations.of(context)!;
        final stats = queueService.getStatistics();
        
        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(child: _buildStatItem(l10n.queued, stats['queued'].toString(), Colors.orange)),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildStatItem(l10n.active, stats['active'].toString(), Colors.blue)),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildStatItem(l10n.completed, stats['completed'].toString(), Colors.green)),
                  const VerticalDivider(width: 1),
                  Expanded(child: _buildStatItem('Failed', stats['failed'].toString(), Colors.red)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.heroTitle(locale).copyWith(
            fontSize: 20,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: AppTextStyles.bodyText(locale).copyWith(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations l10n) {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        return TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.queue, size: 16),
                  const SizedBox(width: 4),
                  Text('${l10n.queuedTab} (${queueService.totalQueuedCount})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.download, size: 16),
                  const SizedBox(width: 4),
                  Text('${l10n.activeTab} (${queueService.totalActiveCount})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, size: 16),
                  const SizedBox(width: 4),
                  Text('${l10n.completedTab} (${queueService.totalCompletedCount})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error, size: 16),
                  const SizedBox(width: 4),
                  Text('${l10n.failedTab} (${queueService.totalFailedCount})'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQueuedTab(AppLocalizations l10n) {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        final items = queueService.queuedItems;
        
        if (items.isEmpty) {
          return _buildEmptyState(l10n.noQueuedDownloads, Icons.queue);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildDownloadCard(
              item,
              l10n,
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () => queueService.removeFromQueue(item.id),
                tooltip: l10n.removeFromQueue,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActiveTab(AppLocalizations l10n) {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        final items = queueService.activeDownloads;
        
        if (items.isEmpty) {
          return _buildEmptyState(l10n.noActiveDownloads, Icons.download);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildDownloadCard(
              item,
              l10n,
              showProgress: true,
              trailing: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () => queueService.cancelDownload(item.id),
                tooltip: l10n.cancelDownload,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedTab(AppLocalizations l10n) {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        final items = queueService.completedDownloads;
        
        if (items.isEmpty) {
          return _buildEmptyState(l10n.noCompletedDownloads, Icons.check_circle);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildDownloadCard(
              item,
              l10n,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.filePath != null)
                    IconButton(
                      icon: const Icon(Icons.folder_open, color: Colors.blue),
                      onPressed: () => _openFile(item.filePath!),
                      tooltip: l10n.openFileLocation,
                    ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.grey),
                    onPressed: () => _showDownloadInfo(context, item),
                    tooltip: l10n.showDetails,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFailedTab(AppLocalizations l10n) {
    return Consumer<DownloadQueueService>(
      builder: (context, queueService, child) {
        final items = queueService.failedDownloads;
        
        if (items.isEmpty) {
          return _buildEmptyState(l10n.noFailedDownloads, Icons.error);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildDownloadCard(
              item,
              l10n,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () => queueService.retryDownload(item.id),
                    tooltip: l10n.retryDownload,
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.grey),
                    onPressed: () => _showDownloadInfo(context, item),
                    tooltip: l10n.showErrorDetails,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.bodyText(locale).copyWith(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(
    DownloadItem item,
    AppLocalizations l10n, {
    Widget? trailing,
    bool showProgress = false,
  }) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.url,
                        style: AppTextStyles.bodyText(locale).copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatusChip(item.status, l10n),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.progress,
                    style: AppTextStyles.bodyText(locale).copyWith(fontSize: 12),
                  ),
                ),
              ],
            ),
            if (showProgress && item.status == DownloadStatus.downloading) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            if (item.errorMessage != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.errorMessage!,
                  style: AppTextStyles.bodyText(locale).copyWith(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(DownloadStatus status, AppLocalizations l10n) {
    Color color;
    String text;
    
    switch (status) {
      case DownloadStatus.queued:
        color = Colors.orange;
        text = l10n.queued;
        break;
      case DownloadStatus.downloading:
        color = Colors.blue;
        text = 'Downloading';
        break;
      case DownloadStatus.completed:
        color = Colors.green;
        text = l10n.completed;
        break;
      case DownloadStatus.failed:
        color = Colors.red;
        text = 'Failed';
        break;
      case DownloadStatus.cancelled:
        color = Colors.grey;
        text = 'Cancelled';
        break;
      case DownloadStatus.paused:
        color = Colors.amber;
        text = 'Paused';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAll),
        content: const Text(
          'This will clear all completed and failed downloads. Active downloads will continue running.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _queueService.clearAll();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }

  Future<void> _openFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        final l10n = AppLocalizations.of(context)!;
        _showErrorSnackBar('${l10n.couldNotOpenFolder}: $filePath');
        return;
      }

      final directory = path.dirname(filePath);
      
      if (Platform.isWindows) {
        // Open file explorer and select the file
        await Process.run('explorer', ['/select,', filePath]);
      } else if (Platform.isMacOS) {
        // Open Finder and select the file
        await Process.run('open', ['-R', filePath]);
      } else if (Platform.isLinux) {
        // Try to open the directory (file selection varies by file manager)
        try {
          await Process.run('xdg-open', [directory]);
        } catch (e) {
          // Fallback to nautilus if available
          try {
            await Process.run('nautilus', ['--select', filePath]);
          } catch (e2) {
            // Final fallback - just open the directory
            await Process.run('xdg-open', [directory]);
          }
        }
      } else {
        // Fallback for other platforms - just show the path
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File location: $filePath')),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      _showErrorSnackBar('${l10n.couldNotOpenFolder}: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDownloadInfo(BuildContext context, DownloadItem item) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('URL:', item.url),
              _buildInfoRow('Status:', item.status.name),
              _buildInfoRow('Format:', item.format),
              _buildInfoRow('Quality:', item.quality),
              _buildInfoRow('Audio Only:', item.audioOnly ? 'Yes' : 'No'),
              _buildInfoRow('Subtitles:', item.downloadSubtitles ? 'Yes' : 'No'),
              _buildInfoRow('Created:', _formatDateTime(item.createdAt)),
              if (item.startedAt != null)
                _buildInfoRow('Started:', _formatDateTime(item.startedAt!)),
              if (item.completedAt != null)
                _buildInfoRow('Completed:', _formatDateTime(item.completedAt!)),
              if (item.filePath != null)
                _buildInfoRow('File Path:', item.filePath!),
              if (item.errorMessage != null)
                _buildInfoRow('Error:', item.errorMessage!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
           '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
