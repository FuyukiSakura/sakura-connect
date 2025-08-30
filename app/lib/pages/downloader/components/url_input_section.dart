import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Component for URL input with paste functionality
class UrlInputSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPasteFromClipboard;
  final ValueChanged<String>? onChanged;
  
  const UrlInputSection({
    super.key,
    required this.controller,
    required this.onPasteFromClipboard,
    this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.youtubeUrl,
          style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: l10n.youtubeUrlPlaceholder,
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
            suffixIcon: IconButton(
              onPressed: onPasteFromClipboard,
              icon: const Icon(Icons.paste),
              tooltip: l10n.pasteFromClipboard,
            ),
          ),
          style: AppTextStyles.bodyText(locale),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
