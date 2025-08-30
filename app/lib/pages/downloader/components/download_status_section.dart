import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';

/// Component for displaying download status
class DownloadStatusSection extends StatelessWidget {
  final String status;
  final bool isDownloading;
  
  const DownloadStatusSection({
    super.key,
    required this.status,
    required this.isDownloading,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDownloading 
          ? AppColors.lightBlue 
          : status.contains('failed')
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: isDownloading 
            ? AppColors.primary.withValues(alpha: 0.2)
            : status.contains('failed')
              ? Colors.red.withValues(alpha: 0.3)
              : Colors.green.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Download Status',
            style: AppTextStyles.resultLabel(locale),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: AppTextStyles.bodyText(locale),
          ),
          if (isDownloading) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}
