// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Sakura Connect';

  @override
  String get heroTitle => 'Sakura Connect';

  @override
  String get heroSubtitle => 'あなたのニコ生コネクト';

  @override
  String get enterTextToTranslate => '翻訳するテキストを入力';

  @override
  String get inputPlaceholder => 'ここにメッセージを入力してください...';

  @override
  String get translateButton => '翻訳';

  @override
  String get translatingButton => '翻訳中...';

  @override
  String get translationResult => '翻訳結果';

  @override
  String get featuresTitle => '機能';

  @override
  String get aiTranslationTitle => 'AI翻訳';

  @override
  String get aiTranslationDescription => '高度なAIモデルによる翻訳';

  @override
  String get socialReadyTitle => 'ソーシャル対応';

  @override
  String get socialReadyDescription => 'ソーシャルプラットフォーム向けに最適化';

  @override
  String get errorInvalidText => '翻訳する有効なテキストを入力してください';

  @override
  String get errorTranslationFailed => '翻訳に失敗しました。もう一度お試しください。';

  @override
  String get languageEnglish => '英語';

  @override
  String get languageSpanish => 'スペイン語';

  @override
  String get languageFrench => 'フランス語';

  @override
  String get languageGerman => 'ドイツ語';

  @override
  String get languageChinese => '簡体字中国語';

  @override
  String get languageJapanese => '日本語';

  @override
  String get languageKorean => '韓国語';

  @override
  String get languageChineseTraditional => '繁体字中国語';

  @override
  String get displayLanguage => '表示言語';

  @override
  String get translationFeature => 'ダウンローダー';

  @override
  String get aboutFeature => 'について';

  @override
  String get youtubeVideoDownloader => 'YouTube動画ダウンローダー';

  @override
  String get youtubeUrl => 'YouTube URL';

  @override
  String get youtubeUrlPlaceholder => 'https://www.youtube.com/watch?v=...';

  @override
  String get outputPath => '出力パス（オプション）';

  @override
  String get outputPathPlaceholder => '空白の場合はデフォルトのダウンロードフォルダを使用';

  @override
  String get downloadVideo => '動画をダウンロード';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String get downloadOptions => 'ダウンロードオプション';

  @override
  String get format => '形式';

  @override
  String get quality => '品質';

  @override
  String get audioOnly => '音声のみ';

  @override
  String get audioOnlyDescription => '音声トラックのみをダウンロード';

  @override
  String get downloadSubtitles => '字幕をダウンロード';

  @override
  String get downloadSubtitlesDescription => '利用可能な字幕をダウンロード';

  @override
  String get pasteFromClipboard => 'クリップボードから貼り付け';

  @override
  String get selectDownloadFolder => 'ダウンロードフォルダを選択';

  @override
  String get pleaseEnterValidUrl => '有効なYouTube URLを入力してください';

  @override
  String get failedToPasteFromClipboard => 'クリップボードからの貼り付けに失敗しました';

  @override
  String get setupHelp => 'セットアップヘルプ';

  @override
  String get close => '閉じる';

  @override
  String get retrySetup => 'セットアップを再試行';

  @override
  String get downloadInformation => 'ダウンロード情報';

  @override
  String get ytdlpSetup => 'yt-dlpセットアップ';

  @override
  String get downloadQueue => 'ダウンロードキュー';

  @override
  String get embeddedYtdlpStatus => '組み込みyt-dlpステータス';

  @override
  String get downloaderFeature => 'YouTubeダウンローダー';

  @override
  String get queueFeature => 'ダウンロードキュー';

  @override
  String get setupFeature => 'yt-dlp設定';

  @override
  String get downloadPath => 'ダウンロードパス';

  @override
  String get subtitles => '字幕';

  @override
  String get subtitlesDescription => '利用可能な字幕をダウンロード';

  @override
  String get additionalOptions => '追加オプション';

  @override
  String get download => 'ダウンロード';

  @override
  String get adding => '追加中...';

  @override
  String get selectFolder => 'フォルダを選択';

  @override
  String get openFolder => 'フォルダを開く';

  @override
  String get editFolder => 'フォルダを編集';

  @override
  String get setupRequired => '設定が必要';

  @override
  String get setupRequiredMessage =>
      'yt-dlpがインストールされていないか準備ができていません。動画をダウンロードする前に設定する必要があります。';

  @override
  String get goToSetup => '設定に移動';

  @override
  String get noDownloads => 'ダウンロードなし';

  @override
  String get active => 'アクティブ';

  @override
  String get queued => 'キューに追加済み';

  @override
  String get completed => '完了';

  @override
  String get queuedTab => 'キュー';

  @override
  String get activeTab => 'アクティブ';

  @override
  String get completedTab => '完了';

  @override
  String get failedTab => '失敗';

  @override
  String get noQueuedDownloads => 'キューにダウンロードがありません';

  @override
  String get noActiveDownloads => 'アクティブなダウンロードがありません';

  @override
  String get noCompletedDownloads => '完了したダウンロードがありません';

  @override
  String get noFailedDownloads => '失敗したダウンロードがありません';

  @override
  String get removeFromQueue => 'キューから削除';

  @override
  String get cancelDownload => 'ダウンロードをキャンセル';

  @override
  String get retryDownload => 'ダウンロードを再試行';

  @override
  String get showDetails => '詳細を表示';

  @override
  String get showErrorDetails => 'エラー詳細を表示';

  @override
  String get openFileLocation => 'ファイルの場所を開く';

  @override
  String get concurrentDownloads => '同時ダウンロード';

  @override
  String get maxConcurrentDownloads => '同時ダウンロードの最大数：';

  @override
  String get clearCompleted => '完了済みをクリア';

  @override
  String get clearFailed => '失敗をクリア';

  @override
  String get clearAll => 'すべてクリア';

  @override
  String get cancel => 'キャンセル';

  @override
  String get retry => '再試行';

  @override
  String get ytdlpStatus => 'yt-dlpステータス';

  @override
  String get ytdlpReady => '準備完了';

  @override
  String get ytdlpNotReady => '準備未完了';

  @override
  String get checking => '確認中...';

  @override
  String get actions => 'アクション';

  @override
  String get installYtdlp => 'yt-dlpをインストール';

  @override
  String get installing => 'インストール中...';

  @override
  String get update => '更新';

  @override
  String get updating => '更新中...';

  @override
  String get delete => '削除';

  @override
  String get versionManagement => 'バージョン管理';

  @override
  String get availableVersions => '利用可能なバージョン：';

  @override
  String get currentVersion => '現在のバージョン';

  @override
  String get installSelectedVersion => '選択したバージョンをインストール';

  @override
  String get loadingVersions => '利用可能なバージョンを読み込み中...';

  @override
  String get unableToLoadVersions => '利用可能なバージョンを読み込めません。インターネット接続を確認してください。';

  @override
  String get aboutYtdlp => 'yt-dlpについて';

  @override
  String get ytdlpDescription =>
      'yt-dlpは、YouTubeやその他のサイトから動画をダウンロードする強力なコマンドラインプログラムです。このアプリは自動的にyt-dlpバイナリをダウンロードして管理します。';

  @override
  String get features => '機能：';

  @override
  String get downloadStatus => 'ダウンロードステータス';

  @override
  String get pathInfo => 'パス情報';

  @override
  String get filesSavedTo => 'ファイルの保存先：';

  @override
  String get loading => '読み込み中...';

  @override
  String get queueSummary => 'ダウンロードキューの概要';

  @override
  String get successRate => '成功率：';

  @override
  String get maxConcurrent => '最大同時：';

  @override
  String get downloadAddedToQueue =>
      'ダウンロードがキューに追加されました！進行状況を監視するにはキュータブを確認してください。';

  @override
  String get ytdlpNotAvailable => 'yt-dlpが利用できません。インターネット接続を確認してアプリを再起動してください。';

  @override
  String get cannotCreateDirectory => 'ダウンロードディレクトリを作成できません';

  @override
  String get noWritePermission => 'ディレクトリへの書き込み権限がありません';

  @override
  String get failedToAddToQueue => 'キューへの追加に失敗しました';

  @override
  String get failedToSelectFolder => 'フォルダの選択に失敗しました';

  @override
  String get couldNotOpenFolder => 'フォルダを開けませんでした';

  @override
  String get ytdlpInitializedSuccessfully => 'yt-dlpが正常に初期化されました！';

  @override
  String get ytdlpDeletedSuccessfully => 'yt-dlpが正常に削除されました！';

  @override
  String get deleteYtdlpConfirmTitle => 'yt-dlpを削除';

  @override
  String get deleteYtdlpConfirmMessage =>
      'yt-dlpバイナリを削除してもよろしいですか？アプリを使用するには再度ダウンロードする必要があります。';

  @override
  String get aboutPageTitle => 'について';

  @override
  String get aboutAppTitle => '配信をブーストしよう';

  @override
  String get aboutAppDescription =>
      'コンテンツ制作ワークフローを向上させるために設計された強力な配信ツールキット。YouTube動画をダウンロードし、コンテンツライブラリを管理し、プロ仕様のツールで配信体験を向上させましょう。';

  @override
  String get keyFeaturesTitle => '主な機能：';

  @override
  String get featureVideoDownload => '• YouTube動画とプレイリストのダウンロード';

  @override
  String get featureMultipleFormats => '• 複数の形式と品質オプション';

  @override
  String get featureAudioDownload => '• 音声のみダウンロード対応';

  @override
  String get featureSubtitleDownload => '• 字幕ダウンロード機能';

  @override
  String get featureCleanInterface => '• クリーンで直感的なインターフェース';

  @override
  String get featureCrossPlatform => '• クロスプラットフォーム対応';

  @override
  String get videoDownloadCardTitle => '動画ダウンロード';

  @override
  String get videoDownloadCardDescription => '様々な形式でYouTube動画をダウンロード';

  @override
  String get qualityOptionsCardTitle => '品質オプション';

  @override
  String get qualityOptionsCardDescription => '複数の品質設定から選択';

  @override
  String get developerTitle => '開発者';

  @override
  String get developerName => 'FuyukiSakura (冬雪桜)';

  @override
  String get socialLinksTitle => 'つながりましょう：';

  @override
  String get githubRepo => 'GitHubリポジトリ';

  @override
  String get twitterProfile => 'Twitter/Xプロフィール';

  @override
  String get youtubeChannel => 'YouTubeチャンネル';

  @override
  String get twitchChannel => 'Twitchチャンネル';
}
