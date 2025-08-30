
# さくらコネクト - 配信をブースト

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

<div align="center">
  <img src="app/assets/images/logo.png" alt="Sakura Connect Logo" width="128" height="128">
  
  **コンテンツ制作ワークフローを強化するために設計された強力な配信ツールキット**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
</div>

## 🌟 概要

Sakura Connect は、人気の YouTube ダウンローダーである yt-dlp の最新 GUI を提供する、美しくクロスプラットフォームな Flutter アプリです。配信者とクリエイターのために設計され、動画コンテンツのダウンロード、管理、整理をプロ仕様のツールで効率化します。

### ✨ 主な機能

- **🎥 動画ダウンロード**: YouTube の動画や再生リストを様々な形式で保存
- **🎵 音声抽出**: 音声のみのダウンロードに対応
- **📝 字幕対応**: 複数言語の字幕をダウンロード
- **⚡ キュー管理**: 同時ダウンロードと賢いキュー制御
- **🎨 美しいUI**: 直感的で洗練されたモダンデザイン
- **🌍 多言語対応**: 英語・日本語・中国語をサポート
- **🖥️ マルチプラットフォーム**: Windows / macOS / Linux / iOS / Android
- **⚙️ 品質設定**: 形式と品質を柔軟に選択
- **📁 スマート整理**: 自動的なファイル管理と整理

## 🚀 はじめに

### 必要条件

- Flutter SDK 3.32.0 以上
- Dart SDK 3.8.0 以上
- 各プラットフォームの開発ツール（Android Studio / Xcode など）

### インストール手順

1. リポジトリをクローン
   ```bash
   git clone https://github.com/FuyukiSakura/sakura-connect.git
   cd sakura-connect
   ```
2. `app` ディレクトリへ移動
   ```bash
   cd app
   ```
3. 依存関係を取得
   ```bash
   flutter pub get
   ```
4. ローカライズファイルを生成
   ```bash
   flutter gen-l10n
   ```
5. アプリを起動
   ```bash
   flutter run
   ```

## 📦 依存ライブラリ

### コア
- flutter / flutter_localizations
- provider ^6.1.2
- shared_preferences ^2.2.2
- path_provider ^2.1.1
- http ^1.1.0

### UI・デザイン
- google_fonts ^6.3.0
- cupertino_icons ^1.0.8

### ファイル・システム連携
- file_picker ^10.1.1
- permission_handler ^12.0.1
- url_launcher ^6.2.2

### i18n
- intl

### 開発
- flutter_test / flutter_lints ^5.0.0
- flutter_launcher_icons ^0.14.3

## 🏗️ アーキテクチャ

```
app/
├── lib/
│   ├── components/
│   ├── l10n/
│   ├── pages/
│   │   └── downloader/
│   ├── providers/
│   ├── services/
│   └── theme/
└── assets/
```

主要サービス:
- YtdlpService / DownloadQueueService / FileManagerService / PreferencesService / EmbeddedYtdlpService

## 🌍 ローカライズ
- 英語 / 日本語 / 中国語（繁体）に対応
- 追加する場合は `app/lib/l10n/app_[locale].arb` を作成し、`flutter gen-l10n` を実行

## 🎨 デザイン
- さくら色を基調にしたモダンな配色
- レスポンシブレイアウト、Material 3、Google Fonts

## 📄 ライセンス

このプロジェクトは Apache License 2.0 です。詳細は [LICENSE](LICENSE) を参照してください。

## 👨‍💻 開発者

**FuyukiSakura (冬雪桜)**

- GitHub: [@FuyukiSakura](https://github.com/FuyukiSakura)
- Twitter/X: [@FuyukiSakura](https://twitter.com/FuyukiSakura)
- YouTube: [@FuyukiSakura](https://youtube.com/@FuyukiSakura)
- Twitch: [FuyukiSakura](https://twitch.tv/FuyukiSakura)

## 🙏 謝辞
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Flutter](https://flutter.dev/)

---

<div align="center">
  <strong>クリエイターと配信者のために、心を込めて。</strong>
</div>


