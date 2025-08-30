import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Standalone download button component
class DownloadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isDownloading;
  final bool isEnabled;
  
  const DownloadButton({
    super.key,
    required this.onPressed,
    required this.isDownloading,
    required this.isEnabled,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isDownloading || !isEnabled) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isDownloading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.downloading,
                    style: AppTextStyles.buttonText(locale),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.downloadVideo,
                    style: AppTextStyles.buttonText(locale),
                  ),
                ],
              ),
      ),
    );
  }
}
