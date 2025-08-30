
# Sakura Connect - 提升你的直播

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

<div align="center">
  <img src="app/assets/images/logo.png" alt="Sakura Connect Logo" width="128" height="128">
  
  **為內容創作者打造的專業直播工具套件，強化你的製作流程**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
</div>

## 🌟 簡介

Sakura Connect 是一款美觀、跨平台的 Flutter 應用程式，為 yt-dlp（知名 YouTube 下載工具）提供現代化的圖形介面。專為實況主與內容創作者設計，透過專業級工具協助你下載、管理與整理影片內容。

### ✨ 主要功能

- **🎥 影片下載**：以多種格式下載 YouTube 影片與播放清單
- **🎵 音訊抽取**：支援僅音訊下載（音樂、Podcast）
- **📝 字幕支援**：下載多語言字幕
- **⚡ 佇列管理**：支援同時下載與智能佇列
- **🎨 優雅介面**：現代設計、清晰易用
- **🌍 多語系**：完整 i18n（英文/日文/中文）
- **🖥️ 跨平台**：Windows / macOS / Linux / iOS / Android
- **⚙️ 品質控制**：多格式與品質選擇
- **📁 智慧整理**：自動化檔案管理

## 🚀 快速開始

### 需求

- Flutter SDK 3.32.0 以上
- Dart SDK 3.8.0 以上
- 各平台相應開發工具（Android Studio、Xcode 等）

### 安裝步驟

1. 下載專案
   ```bash
   git clone https://github.com/FuyukiSakura/sakura-connect.git
   cd sakura-connect
   ```
2. 進入 `app` 目錄
   ```bash
   cd app
   ```
3. 安裝依賴
   ```bash
   flutter pub get
   ```
4. 生成在地化檔案
   ```bash
   flutter gen-l10n
   ```
5. 執行應用程式
   ```bash
   flutter run
   ```

## 📦 相依套件

### 核心
- flutter / flutter_localizations
- provider ^6.1.2
- shared_preferences ^2.2.2
- path_provider ^2.1.1
- http ^1.1.0

### 介面與設計
- google_fonts ^6.3.0
- cupertino_icons ^1.0.8

### 檔案與系統整合
- file_picker ^10.1.1
- permission_handler ^12.0.1
- url_launcher ^6.2.2

### 國際化
- intl

### 開發
- flutter_test / flutter_lints ^5.0.0
- flutter_launcher_icons ^0.14.3

## 🏗️ 架構

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

主要服務：
- YtdlpService / DownloadQueueService / FileManagerService / PreferencesService / EmbeddedYtdlpService

## 🌍 國際化
- 目前支援：英文 / 日文 / 中文（繁體）
- 新增語言：新增 `app/lib/l10n/app_[locale].arb` 後執行 `flutter gen-l10n`

## 🎨 設計
- 櫻花風格配色、響應式版面、Material 3、Google Fonts

## 📄 授權條款

本專案採用 Apache License 2.0 授權條款，詳見 [LICENSE](LICENSE)。

## 👨‍💻 開發者

**FuyukiSakura (冬雪桜)**

- GitHub: [@FuyukiSakura](https://github.com/FuyukiSakura)
- Twitter/X: [@FuyukiSakura](https://twitter.com/FuyukiSakura)
- YouTube: [@FuyukiSakura](https://youtube.com/@FuyukiSakura)
- Twitch: [FuyukiSakura](https://twitch.tv/FuyukiSakura)

## 🙏 致謝
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [Flutter](https://flutter.dev/)

---

<div align="center">
  <strong>以熱愛打造，獻給所有創作者與實況主。</strong>
</div>


