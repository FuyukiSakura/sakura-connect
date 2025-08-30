# Sakura Connect - Boost Your Stream

[English](README.md) | [日本語](README.ja.md) | [中文](README.zh.md)

<div align="center">
  <img src="app/assets/images/logo.png" alt="Sakura Connect Logo" width="128" height="128">
  
  **A powerful streaming toolkit designed to enhance your content creation workflow**
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-3.8.0+-blue.svg)](https://dart.dev/)
  [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
</div>

## 🌟 Overview

Sakura Connect is a beautiful, cross-platform Flutter application that provides a modern graphical interface for yt-dlp, the popular YouTube video downloader. Built with content creators and streamers in mind, it offers professional-grade tools to download, manage, and organize your video content library.

### ✨ Key Features

- **🎥 Video Download**: Download YouTube videos and playlists in various formats
- **🎵 Audio Extraction**: Audio-only download support for music and podcasts  
- **📝 Subtitle Support**: Download available subtitles in multiple languages
- **⚡ Queue Management**: Concurrent downloads with intelligent queue system
- **🎨 Beautiful UI**: Clean, intuitive interface with modern design
- **🌍 Multi-language**: Full internationalization support (English, Japanese, Chinese)
- **🖥️ Cross-platform**: Works on Windows, macOS, Linux, iOS, and Android
- **⚙️ Quality Control**: Multiple format and quality options
- **📁 Smart Organization**: Automatic file management and organization

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.32.0 or higher
- Dart SDK 3.8.0 or higher
- Platform-specific development tools (Android Studio, Xcode, etc.)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/FuyukiSakura/sakura-connect.git
   cd sakura-connect
   ```

2. **Navigate to the app directory**
   ```bash
   cd app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- **[flutter](https://flutter.dev/)** - UI framework
- **[flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)** - Internationalization support
- **[provider](https://pub.dev/packages/provider)** ^6.1.2 - State management
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** ^2.2.2 - Local data persistence
- **[path_provider](https://pub.dev/packages/path_provider)** ^2.1.1 - File system path access
- **[http](https://pub.dev/packages/http)** ^1.1.0 - HTTP client for API calls

### UI & Design
- **[google_fonts](https://pub.dev/packages/google_fonts)** ^6.3.0 - Custom typography
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** ^1.0.8 - iOS-style icons

### File & System Integration
- **[file_picker](https://pub.dev/packages/file_picker)** ^10.1.1 - File selection dialogs
- **[permission_handler](https://pub.dev/packages/permission_handler)** ^12.0.1 - System permissions
- **[url_launcher](https://pub.dev/packages/url_launcher)** ^6.2.2 - External URL handling

### Internationalization
- **[intl](https://pub.dev/packages/intl)** - Date/time formatting and localization utilities

### Development Dependencies
- **[flutter_test](https://docs.flutter.dev/testing)** - Testing framework
- **[flutter_lints](https://pub.dev/packages/flutter_lints)** ^5.0.0 - Linting rules
- **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)** ^0.14.3 - App icon generation

## 🏗️ Architecture

### Project Structure
```
app/
├── lib/
│   ├── components/          # Reusable UI components
│   ├── l10n/               # Localization files
│   ├── pages/              # Application screens
│   │   └── downloader/     # Download-specific components
│   ├── providers/          # State management
│   ├── services/           # Business logic and API services
│   └── theme/              # App theming and styling
├── assets/                 # Static assets (images, fonts)
└── platforms/              # Platform-specific configurations
    ├── android/
    ├── ios/
    ├── linux/
    ├── macos/
    ├── web/
    └── windows/
```

### Key Services
- **YtdlpService**: Core yt-dlp integration and management
- **DownloadQueueService**: Queue management and concurrent downloads
- **FileManagerService**: File system operations and organization
- **PreferencesService**: User settings and preferences
- **EmbeddedYtdlpService**: Embedded yt-dlp binary management

## 🌍 Internationalization

Sakura Connect supports multiple languages with full localization:

- **English** (en) - Default language
- **Japanese** (ja) - 日本語サポート
- **Chinese** (zh) - 中文支持

### Adding New Languages

1. Create a new ARB file in `app/lib/l10n/app_[locale].arb`
2. Add translations for all keys
3. Run `flutter gen-l10n` to generate localization files
4. Update the supported locales in `LocaleProvider`

## 🎨 Theming & Design

The application features a modern, clean design with:

- **Sakura-inspired color palette** with pink and purple accents
- **Responsive layout** that adapts to different screen sizes
- **Material Design 3** components and principles
- **Custom typography** using Google Fonts
- **Consistent spacing** and visual hierarchy
- **Dark/light theme support** (planned)

## 🔧 Configuration

### Environment Setup
The app automatically manages yt-dlp installation and updates. No additional configuration is required for basic usage.

### Custom Settings
- Download paths and organization
- Concurrent download limits
- Quality preferences
- Language selection
- Theme preferences

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**FuyukiSakura (冬雪桜)**

- 🐙 GitHub: [@FuyukiSakura](https://github.com/FuyukiSakura)
- 🐦 Twitter/X: [@FuyukiSakura](https://twitter.com/FuyukiSakura)
- 📺 YouTube: [@FuyukiSakura](https://youtube.com/@FuyukiSakura)
- 🎮 Twitch: [FuyukiSakura](https://twitch.tv/FuyukiSakura)

## 🙏 Acknowledgments

- **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** - The powerful YouTube downloader that powers this application
- **[Flutter Team](https://flutter.dev/)** - For the amazing cross-platform framework
- **Community Contributors** - For bug reports, feature requests, and contributions

## 📊 Project Status

- ✅ Core download functionality
- ✅ Multi-language support
- ✅ Cross-platform compatibility
- ✅ Queue management system
- 🔄 Advanced filtering options (in progress)
- 🔄 Dark theme support (planned)
- 🔄 Playlist management (planned)
- 🔄 Download history and analytics (planned)

---

<div align="center">
  <strong>Built with ❤️ for content creators and streamers worldwide</strong>
</div>
