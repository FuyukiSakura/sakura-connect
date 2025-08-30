import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../components/feature_card.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleProvider>(context).locale;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(l10n, locale),
          const SizedBox(height: 32),
          _buildFeaturesSection(l10n, locale),
          const SizedBox(height: 32),
          _buildAboutSection(l10n, locale),
          const SizedBox(height: 32),
          _buildDeveloperSection(l10n, locale),
        ],
      ),
    );
  }

  Widget _buildHeroSection(AppLocalizations l10n, Locale? locale) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.heroTitle,
            style: AppTextStyles.heroTitle(locale),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.heroSubtitle,
            style: AppTextStyles.heroSubtitle(locale),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(AppLocalizations l10n, Locale? locale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.featuresTitle,
          style: AppTextStyles.sectionTitle(locale),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FeatureCard(
                icon: Icons.download,
                title: l10n.videoDownloadCardTitle,
                description: l10n.videoDownloadCardDescription,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FeatureCard(
                icon: Icons.high_quality,
                title: l10n.qualityOptionsCardTitle,
                description: l10n.qualityOptionsCardDescription,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(AppLocalizations l10n, Locale? locale) {
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
              l10n.aboutAppTitle,
              style: AppTextStyles.cardTitle(locale),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.aboutAppDescription,
              style: AppTextStyles.bodyText(locale),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.keyFeaturesTitle,
              style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildFeaturePoint(l10n.featureVideoDownload, locale),
            _buildFeaturePoint(l10n.featureMultipleFormats, locale),
            _buildFeaturePoint(l10n.featureAudioDownload, locale),
            _buildFeaturePoint(l10n.featureSubtitleDownload, locale),
            _buildFeaturePoint(l10n.featureCleanInterface, locale),
            _buildFeaturePoint(l10n.featureCrossPlatform, locale),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturePoint(String text, Locale? locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: AppTextStyles.bodyText(locale),
      ),
    );
  }

  Widget _buildDeveloperSection(AppLocalizations l10n, Locale? locale) {
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
              l10n.developerTitle,
              style: AppTextStyles.cardTitle(locale),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.developerName,
              style: AppTextStyles.bodyText(locale).copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.socialLinksTitle,
              style: AppTextStyles.cardTitle(locale).copyWith(fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildSocialLink(
              icon: Icons.code,
              text: l10n.githubRepo,
              url: 'https://github.com/FuyukiSakura/sakura-connect',
            ),
            const SizedBox(height: 8),
            _buildSocialLink(
              icon: Icons.alternate_email,
              text: l10n.twitterProfile,
              url: 'https://twitter.com/FuyukiSakura',
            ),
            const SizedBox(height: 8),
            _buildSocialLink(
              icon: Icons.play_circle_outline,
              text: l10n.youtubeChannel,
              url: 'https://youtube.com/@FuyukiSakura',
            ),
            const SizedBox(height: 8),
            _buildSocialLink(
              icon: Icons.videocam,
              text: l10n.twitchChannel,
              url: 'https://twitch.tv/FuyukiSakura',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLink({
    required IconData icon,
    required String text,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      // Handle error - could show a snackbar or dialog
      debugPrint('Could not launch $urlString');
    }
  }
} 