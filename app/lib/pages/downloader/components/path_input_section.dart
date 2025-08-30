import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Component for output path selection
class PathInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSelectFolder;
  final VoidCallback onOpenFolder;
  
  const PathInputSection({
    super.key,
    required this.controller,
    required this.onSelectFolder,
    required this.onOpenFolder,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.outputPath,
          style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.outputPathPlaceholder,
            hintStyle: AppTextStyles.hintText(locale),
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
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: onOpenFolder,
                  icon: const Icon(Icons.folder_open),
                  tooltip: 'Open folder',
                ),
                IconButton(
                  onPressed: onSelectFolder,
                  icon: const Icon(Icons.edit),
                  tooltip: l10n.selectDownloadFolder,
                ),
              ],
            ),
          ),
          style: AppTextStyles.bodyText(locale),
          readOnly: true,
        ),
      ],
    );
  }
}
