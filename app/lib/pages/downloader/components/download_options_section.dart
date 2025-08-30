import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../theme/app_theme.dart';
import '../constants.dart';
import '../types.dart';

/// Component for download options (format, quality, audio only, subtitles)
class DownloadOptionsSection extends StatelessWidget {
  final DownloadOptions options;
  final ValueChanged<DownloadOptions> onOptionsChanged;
  
  const DownloadOptionsSection({
    super.key,
    required this.options,
    required this.onOptionsChanged,
  });
  
  @override
  Widget build(BuildContext context) {
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
              'Download Options',
              style: AppTextStyles.cardTitle(locale),
            ),
            const SizedBox(height: 16),
            _buildFormatSelector(locale),
            const SizedBox(height: 16),
            _buildQualitySelector(locale),
            const SizedBox(height: 16),
            _buildCheckboxOptions(locale),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFormatSelector(Locale? locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Format',
          style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options.format,
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
          items: DownloaderConstants.formats.map((format) {
            return DropdownMenuItem<String>(
              value: format,
              child: Text(
                format.toUpperCase(),
                style: AppTextStyles.bodyText(locale),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onOptionsChanged(options.copyWith(format: value));
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildQualitySelector(Locale? locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality',
          style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: options.quality,
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
          items: DownloaderConstants.qualities.map((quality) {
            return DropdownMenuItem<String>(
              value: quality,
              child: Text(
                quality,
                style: AppTextStyles.bodyText(locale),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onOptionsChanged(options.copyWith(quality: value));
            }
          },
        ),
      ],
    );
  }
  
  Widget _buildCheckboxOptions(Locale? locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Options',
          style: AppTextStyles.bodyText(locale).copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildToggleButton(
              label: 'Audio Only',
              icon: Icons.headphones,
              subtitle: 'Download only the audio track',
              isSelected: options.audioOnly,
              onTap: () {
                onOptionsChanged(options.copyWith(audioOnly: !options.audioOnly));
              },
              color: Colors.purple,
            ),
            _buildToggleButton(
              label: 'Subtitles',
              icon: Icons.subtitles,
              subtitle: 'Download available subtitles',
              isSelected: options.downloadSubtitles,
              onTap: () {
                onOptionsChanged(options.copyWith(downloadSubtitles: !options.downloadSubtitles));
              },
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
              ? color.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                ? color.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? color : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? color : Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? color : Colors.grey.shade400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
