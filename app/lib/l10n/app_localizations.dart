import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// Main application title
  ///
  /// In en, this message translates to:
  /// **'Sakura Connect'**
  String get appTitle;

  /// Hero section title
  ///
  /// In en, this message translates to:
  /// **'Sakura Connect'**
  String get heroTitle;

  /// Hero section subtitle
  ///
  /// In en, this message translates to:
  /// **'Your streaming companion'**
  String get heroSubtitle;

  /// Translation section title
  ///
  /// In en, this message translates to:
  /// **'Enter text to translate'**
  String get enterTextToTranslate;

  /// Text input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get inputPlaceholder;

  /// Translate button text
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translateButton;

  /// Translate button text when loading
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translatingButton;

  /// Translation result section title
  ///
  /// In en, this message translates to:
  /// **'Translation Result'**
  String get translationResult;

  /// Features section title
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get featuresTitle;

  /// AI Translation feature title
  ///
  /// In en, this message translates to:
  /// **'AI Translation'**
  String get aiTranslationTitle;

  /// AI Translation feature description
  ///
  /// In en, this message translates to:
  /// **'Powered by advanced AI models'**
  String get aiTranslationDescription;

  /// Social Ready feature title
  ///
  /// In en, this message translates to:
  /// **'Social Ready'**
  String get socialReadyTitle;

  /// Social Ready feature description
  ///
  /// In en, this message translates to:
  /// **'Optimized for social platforms'**
  String get socialReadyDescription;

  /// Error message for invalid text input
  ///
  /// In en, this message translates to:
  /// **'Please enter valid text to translate'**
  String get errorInvalidText;

  /// Error message when translation fails
  ///
  /// In en, this message translates to:
  /// **'Translation failed. Please try again.'**
  String get errorTranslationFailed;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// Simplified Chinese language name
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChinese;

  /// Japanese language name
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJapanese;

  /// Korean language name
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKorean;

  /// Traditional Chinese language name
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get languageChineseTraditional;

  /// Display language selector label
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get displayLanguage;

  /// Downloader feature navigation item
  ///
  /// In en, this message translates to:
  /// **'Downloader'**
  String get translationFeature;

  /// About feature navigation item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutFeature;

  /// Main downloader section title
  ///
  /// In en, this message translates to:
  /// **'YouTube Video Downloader'**
  String get youtubeVideoDownloader;

  /// YouTube URL input label
  ///
  /// In en, this message translates to:
  /// **'YouTube URL'**
  String get youtubeUrl;

  /// YouTube URL input placeholder
  ///
  /// In en, this message translates to:
  /// **'https://www.youtube.com/watch?v=...'**
  String get youtubeUrlPlaceholder;

  /// Output path input label
  ///
  /// In en, this message translates to:
  /// **'Output Path (Optional)'**
  String get outputPath;

  /// Output path input placeholder
  ///
  /// In en, this message translates to:
  /// **'Leave empty for default Downloads folder'**
  String get outputPathPlaceholder;

  /// Download video section title
  ///
  /// In en, this message translates to:
  /// **'Download Video'**
  String get downloadVideo;

  /// Download button text when downloading
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// Download options section title
  ///
  /// In en, this message translates to:
  /// **'Download Options'**
  String get downloadOptions;

  /// Format selector label
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// Quality selector label
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get quality;

  /// Audio only option label
  ///
  /// In en, this message translates to:
  /// **'Audio Only'**
  String get audioOnly;

  /// Audio only option description
  ///
  /// In en, this message translates to:
  /// **'Download only the audio track'**
  String get audioOnlyDescription;

  /// Download subtitles checkbox label
  ///
  /// In en, this message translates to:
  /// **'Download Subtitles'**
  String get downloadSubtitles;

  /// Download subtitles checkbox description
  ///
  /// In en, this message translates to:
  /// **'Download available subtitles'**
  String get downloadSubtitlesDescription;

  /// Paste from clipboard tooltip
  ///
  /// In en, this message translates to:
  /// **'Paste from clipboard'**
  String get pasteFromClipboard;

  /// Folder selection button tooltip
  ///
  /// In en, this message translates to:
  /// **'Select download folder'**
  String get selectDownloadFolder;

  /// Invalid URL error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid YouTube URL'**
  String get pleaseEnterValidUrl;

  /// Failed to paste from clipboard error message
  ///
  /// In en, this message translates to:
  /// **'Failed to paste from clipboard'**
  String get failedToPasteFromClipboard;

  /// Setup help dialog title
  ///
  /// In en, this message translates to:
  /// **'Setup Help'**
  String get setupHelp;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Retry setup button text
  ///
  /// In en, this message translates to:
  /// **'Retry Setup'**
  String get retrySetup;

  /// Download information section title
  ///
  /// In en, this message translates to:
  /// **'Download Information'**
  String get downloadInformation;

  /// yt-dlp setup navigation item
  ///
  /// In en, this message translates to:
  /// **'yt-dlp Setup'**
  String get ytdlpSetup;

  /// Download queue navigation item
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get downloadQueue;

  /// Embedded yt-dlp status section title
  ///
  /// In en, this message translates to:
  /// **'Embedded yt-dlp Status'**
  String get embeddedYtdlpStatus;

  /// Downloader feature name
  ///
  /// In en, this message translates to:
  /// **'YouTube Downloader'**
  String get downloaderFeature;

  /// Queue feature name
  ///
  /// In en, this message translates to:
  /// **'Download Queue'**
  String get queueFeature;

  /// Setup feature name
  ///
  /// In en, this message translates to:
  /// **'yt-dlp Setup'**
  String get setupFeature;

  /// Download path input label
  ///
  /// In en, this message translates to:
  /// **'Download Path'**
  String get downloadPath;

  /// Subtitles option label
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// Subtitles option description
  ///
  /// In en, this message translates to:
  /// **'Download available subtitles'**
  String get subtitlesDescription;

  /// Additional options section title
  ///
  /// In en, this message translates to:
  /// **'Additional Options'**
  String get additionalOptions;

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// Download button text when adding to queue
  ///
  /// In en, this message translates to:
  /// **'Adding...'**
  String get adding;

  /// Select folder tooltip
  ///
  /// In en, this message translates to:
  /// **'Select folder'**
  String get selectFolder;

  /// Open folder tooltip
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get openFolder;

  /// Edit folder tooltip
  ///
  /// In en, this message translates to:
  /// **'Edit folder'**
  String get editFolder;

  /// Setup required section title
  ///
  /// In en, this message translates to:
  /// **'Setup Required'**
  String get setupRequired;

  /// Setup required message
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is not installed or ready. You need to set it up before you can download videos.'**
  String get setupRequiredMessage;

  /// Go to setup button text
  ///
  /// In en, this message translates to:
  /// **'Go to Setup'**
  String get goToSetup;

  /// No downloads status text
  ///
  /// In en, this message translates to:
  /// **'No downloads'**
  String get noDownloads;

  /// Active downloads status text
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get active;

  /// Queued downloads status text
  ///
  /// In en, this message translates to:
  /// **'queued'**
  String get queued;

  /// Completed downloads status text
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// Queued tab label
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queuedTab;

  /// Active tab label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeTab;

  /// Completed tab label
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get completedTab;

  /// Failed tab label
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failedTab;

  /// No queued downloads message
  ///
  /// In en, this message translates to:
  /// **'No downloads in queue'**
  String get noQueuedDownloads;

  /// No active downloads message
  ///
  /// In en, this message translates to:
  /// **'No active downloads'**
  String get noActiveDownloads;

  /// No completed downloads message
  ///
  /// In en, this message translates to:
  /// **'No completed downloads'**
  String get noCompletedDownloads;

  /// No failed downloads message
  ///
  /// In en, this message translates to:
  /// **'No failed downloads'**
  String get noFailedDownloads;

  /// Remove from queue tooltip
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get removeFromQueue;

  /// Cancel download tooltip
  ///
  /// In en, this message translates to:
  /// **'Cancel download'**
  String get cancelDownload;

  /// Retry download tooltip
  ///
  /// In en, this message translates to:
  /// **'Retry download'**
  String get retryDownload;

  /// Show details tooltip
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get showDetails;

  /// Show error details tooltip
  ///
  /// In en, this message translates to:
  /// **'Show error details'**
  String get showErrorDetails;

  /// Open file location tooltip
  ///
  /// In en, this message translates to:
  /// **'Open file location'**
  String get openFileLocation;

  /// Concurrent downloads setting title
  ///
  /// In en, this message translates to:
  /// **'Concurrent Downloads'**
  String get concurrentDownloads;

  /// Max concurrent downloads description
  ///
  /// In en, this message translates to:
  /// **'Maximum number of simultaneous downloads:'**
  String get maxConcurrentDownloads;

  /// Clear completed downloads menu item
  ///
  /// In en, this message translates to:
  /// **'Clear Completed'**
  String get clearCompleted;

  /// Clear failed downloads menu item
  ///
  /// In en, this message translates to:
  /// **'Clear Failed'**
  String get clearFailed;

  /// Clear all downloads menu item
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// yt-dlp status section title
  ///
  /// In en, this message translates to:
  /// **'yt-dlp Status'**
  String get ytdlpStatus;

  /// yt-dlp ready status
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ytdlpReady;

  /// yt-dlp not ready status
  ///
  /// In en, this message translates to:
  /// **'Not Ready'**
  String get ytdlpNotReady;

  /// Checking status text
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checking;

  /// Actions section title
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Install yt-dlp button text
  ///
  /// In en, this message translates to:
  /// **'Install yt-dlp'**
  String get installYtdlp;

  /// Installing status text
  ///
  /// In en, this message translates to:
  /// **'Installing...'**
  String get installing;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Updating status text
  ///
  /// In en, this message translates to:
  /// **'Updating...'**
  String get updating;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Version management section title
  ///
  /// In en, this message translates to:
  /// **'Version Management'**
  String get versionManagement;

  /// Available versions label
  ///
  /// In en, this message translates to:
  /// **'Available Versions:'**
  String get availableVersions;

  /// Current version badge text
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get currentVersion;

  /// Install selected version button text
  ///
  /// In en, this message translates to:
  /// **'Install Selected Version'**
  String get installSelectedVersion;

  /// Loading versions message
  ///
  /// In en, this message translates to:
  /// **'Loading available versions...'**
  String get loadingVersions;

  /// Unable to load versions error message
  ///
  /// In en, this message translates to:
  /// **'Unable to load available versions. Check your internet connection.'**
  String get unableToLoadVersions;

  /// About yt-dlp section title
  ///
  /// In en, this message translates to:
  /// **'About yt-dlp'**
  String get aboutYtdlp;

  /// yt-dlp description text
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is a powerful command-line program to download videos from YouTube and other sites. This app automatically downloads and manages the yt-dlp binary for you.'**
  String get ytdlpDescription;

  /// Features list title
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// Download status section title
  ///
  /// In en, this message translates to:
  /// **'Download Status'**
  String get downloadStatus;

  /// Path information section title
  ///
  /// In en, this message translates to:
  /// **'Path Information'**
  String get pathInfo;

  /// Files saved to label
  ///
  /// In en, this message translates to:
  /// **'Files will be saved to:'**
  String get filesSavedTo;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Queue summary section title
  ///
  /// In en, this message translates to:
  /// **'Download Queue Summary'**
  String get queueSummary;

  /// Success rate label
  ///
  /// In en, this message translates to:
  /// **'Success Rate:'**
  String get successRate;

  /// Max concurrent label
  ///
  /// In en, this message translates to:
  /// **'Max Concurrent:'**
  String get maxConcurrent;

  /// Download added to queue success message
  ///
  /// In en, this message translates to:
  /// **'Download added to queue! Check the Queue tab to monitor progress.'**
  String get downloadAddedToQueue;

  /// yt-dlp not available error message
  ///
  /// In en, this message translates to:
  /// **'yt-dlp is not available. Please check your internet connection and restart the app.'**
  String get ytdlpNotAvailable;

  /// Cannot create directory error message
  ///
  /// In en, this message translates to:
  /// **'Cannot create download directory'**
  String get cannotCreateDirectory;

  /// No write permission error message
  ///
  /// In en, this message translates to:
  /// **'No write permission for directory'**
  String get noWritePermission;

  /// Failed to add to queue error message
  ///
  /// In en, this message translates to:
  /// **'Failed to add to queue'**
  String get failedToAddToQueue;

  /// Failed to select folder error message
  ///
  /// In en, this message translates to:
  /// **'Failed to select folder'**
  String get failedToSelectFolder;

  /// Could not open folder error message
  ///
  /// In en, this message translates to:
  /// **'Could not open folder'**
  String get couldNotOpenFolder;

  /// yt-dlp initialized successfully message
  ///
  /// In en, this message translates to:
  /// **'yt-dlp initialized successfully!'**
  String get ytdlpInitializedSuccessfully;

  /// yt-dlp deleted successfully message
  ///
  /// In en, this message translates to:
  /// **'yt-dlp deleted successfully!'**
  String get ytdlpDeletedSuccessfully;

  /// Delete yt-dlp confirmation title
  ///
  /// In en, this message translates to:
  /// **'Delete yt-dlp'**
  String get deleteYtdlpConfirmTitle;

  /// Delete yt-dlp confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the yt-dlp binary? You will need to download it again to use the app.'**
  String get deleteYtdlpConfirmMessage;

  /// About page title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutPageTitle;

  /// About section app title
  ///
  /// In en, this message translates to:
  /// **'Boost Your Stream'**
  String get aboutAppTitle;

  /// About section app description
  ///
  /// In en, this message translates to:
  /// **'A powerful streaming toolkit designed to enhance your content creation workflow. Download YouTube videos, manage your content library, and boost your streaming experience with professional-grade tools.'**
  String get aboutAppDescription;

  /// Key features section title
  ///
  /// In en, this message translates to:
  /// **'Key Features:'**
  String get keyFeaturesTitle;

  /// Video download feature
  ///
  /// In en, this message translates to:
  /// **'• Download YouTube videos and playlists'**
  String get featureVideoDownload;

  /// Multiple formats feature
  ///
  /// In en, this message translates to:
  /// **'• Multiple format and quality options'**
  String get featureMultipleFormats;

  /// Audio download feature
  ///
  /// In en, this message translates to:
  /// **'• Audio-only download support'**
  String get featureAudioDownload;

  /// Subtitle download feature
  ///
  /// In en, this message translates to:
  /// **'• Subtitle download capability'**
  String get featureSubtitleDownload;

  /// Clean interface feature
  ///
  /// In en, this message translates to:
  /// **'• Clean and intuitive interface'**
  String get featureCleanInterface;

  /// Cross-platform feature
  ///
  /// In en, this message translates to:
  /// **'• Cross-platform compatibility'**
  String get featureCrossPlatform;

  /// Video download card title
  ///
  /// In en, this message translates to:
  /// **'Video Download'**
  String get videoDownloadCardTitle;

  /// Video download card description
  ///
  /// In en, this message translates to:
  /// **'Download YouTube videos in various formats'**
  String get videoDownloadCardDescription;

  /// Quality options card title
  ///
  /// In en, this message translates to:
  /// **'Quality Options'**
  String get qualityOptionsCardTitle;

  /// Quality options card description
  ///
  /// In en, this message translates to:
  /// **'Choose from multiple quality settings'**
  String get qualityOptionsCardDescription;

  /// Developer section title
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developerTitle;

  /// Developer name
  ///
  /// In en, this message translates to:
  /// **'FuyukiSakura (冬雪桜)'**
  String get developerName;

  /// Social links section title
  ///
  /// In en, this message translates to:
  /// **'Connect with me:'**
  String get socialLinksTitle;

  /// GitHub repository link text
  ///
  /// In en, this message translates to:
  /// **'GitHub Repository'**
  String get githubRepo;

  /// Twitter profile link text
  ///
  /// In en, this message translates to:
  /// **'Twitter/X Profile'**
  String get twitterProfile;

  /// YouTube channel link text
  ///
  /// In en, this message translates to:
  /// **'YouTube Channel'**
  String get youtubeChannel;

  /// Twitch channel link text
  ///
  /// In en, this message translates to:
  /// **'Twitch Channel'**
  String get twitchChannel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
