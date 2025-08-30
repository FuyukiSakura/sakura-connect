import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/locale_provider.dart';
import '../services/embedded_ytdlp_service.dart';

class YtDlpVersionBadge extends StatefulWidget {
  const YtDlpVersionBadge({super.key});

  @override
  State<YtDlpVersionBadge> createState() => _YtDlpVersionBadgeState();
}

class _YtDlpVersionBadgeState extends State<YtDlpVersionBadge> {
  bool _isAvailable = false;
  String? _version;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final available = await EmbeddedYtDlpService.isAvailable();
    final version = await EmbeddedYtDlpService.getVersion();
    
    if (mounted) {
      setState(() {
        _isAvailable = available;
        _version = version;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade600),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Checking...',
              style: AppTextStyles.bodyText(locale).copyWith(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isAvailable 
          ? Colors.green.withValues(alpha: 0.1)
          : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isAvailable 
            ? Colors.green.withValues(alpha: 0.3)
            : Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isAvailable ? Icons.check_circle : Icons.error,
            size: 12,
            color: _isAvailable ? Colors.green.shade700 : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            _isAvailable 
              ? (_version != null ? 'v$_version' : 'Ready')
              : 'Not Ready',
            style: AppTextStyles.bodyText(locale).copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _isAvailable ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
