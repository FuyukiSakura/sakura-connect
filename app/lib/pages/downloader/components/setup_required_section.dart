import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';

/// Component shown when yt-dlp setup is required
class SetupRequiredSection extends StatelessWidget {
  final VoidCallback onGoToSetup;
  
  const SetupRequiredSection({
    super.key,
    required this.onGoToSetup,
  });
  
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Card(
      elevation: 2,
      shadowColor: Colors.red.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.red.withValues(alpha: 0.5),
          width: 2,
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
                  Icons.warning,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Setup Required',
                  style: AppTextStyles.cardTitle(locale).copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'yt-dlp is not installed or ready. You need to set it up before you can download videos.',
              style: AppTextStyles.bodyText(locale),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onGoToSetup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                    label: Text(
                      'Go to Setup',
                      style: AppTextStyles.buttonText(locale),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
