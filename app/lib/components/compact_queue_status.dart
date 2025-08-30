import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../services/download_queue_service.dart';

class CompactQueueStatus extends StatelessWidget {
  final VoidCallback onTap;
  
  const CompactQueueStatus({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return ChangeNotifierProvider.value(
      value: DownloadQueueService(),
      child: Consumer<DownloadQueueService>(
        builder: (context, queueService, child) {
          final stats = queueService.getStatistics();
          final hasActivity = stats['active'] > 0 || stats['queued'] > 0;
          
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: hasActivity 
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: hasActivity 
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasActivity ? Icons.download : Icons.queue_play_next,
                      size: 16,
                      color: hasActivity ? AppColors.primary : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    if (hasActivity) ...[
                      Text(
                        '${stats['active']}',
                        style: AppTextStyles.bodyText(locale).copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        ' active',
                        style: AppTextStyles.bodyText(locale).copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (stats['queued'] > 0) ...[
                        Text(
                          ' • ${stats['queued']} queued',
                          style: AppTextStyles.bodyText(locale).copyWith(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ] else ...[
                      Text(
                        stats['completed'] > 0 
                          ? '${stats['completed']} completed'
                          : 'No downloads',
                        style: AppTextStyles.bodyText(locale).copyWith(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
