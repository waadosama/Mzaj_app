# Mzaj Music App

Mzaj is a modern Flutter music discovery and playlist app that helps users search for tracks by mood, preview them, and build custom playlists.

It combines a vibrant, music-first UI with a local playlist system and real-time search using the iTunes API.

## Features

- Mood and artist-based music search
- Curated vibe chips for quick discovery
- Track results with preview support
- Local playlist creation and management
- Add songs to saved playlists
- Playlist detail views with track management
- Smooth, custom UI with a premium music-app aesthetic
- Cross-platform support for Flutter targets

## Tech Stack

- Flutter
- Dart
- Provider for state management
- HTTP for API requests
- just_audio for music playback
- SQLite via sqflite for local data persistence
- cached_network_image for artwork loading
- Google Fonts for typography

## Project Structure

```text
lib/
├── app.dart
├── main.dart
├── models/
│   ├── playlist.dart
│   └── song.dart
├── providers/
│   └── app_providers.dart
├── screens/
│   ├── results_screen.dart
│   ├── saved_playlists_screen.dart
│   ├── search_screen.dart
│   ├── playlist_detail_screen.dart
│   └── ...
├── services/
│   └── itunes_api.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── add_playlist_dialog.dart
│   ├── add_songs_dialog.dart
│   ├── playlist_card.dart
│   └── ...
└── main.dart
```

## Prerequisites

Before running the app, make sure you have the following installed:

- Flutter SDK (compatible with the project version in `pubspec.yaml`)
- Android Studio or VS Code with Flutter support
- An emulator or physical device connected

## Installation

1. Clone the repository:

```bash
git clone <your-repository-url>
cd Music_app - Copy
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Useful Commands

### Run in debug mode

```bash
flutter run
```

### Check for issues

```bash
flutter analyze
```

### Run tests

```bash
flutter test
```

### Build for Android

```bash
flutter build apk
```

## App Flow

1. Open the app and begin on the search screen.
2. Search for a song, artist, or vibe.
3. Browse matching tracks from the iTunes catalog.
4. Save favorite music into playlists.
5. Manage and revisit your playlists from the saved playlists screen.

## Notes

- Playlist data is stored locally in the app, so it remains available on the device.
- Song search uses live results from the iTunes API, which may vary based on the query and availability.
