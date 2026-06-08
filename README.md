# Pulse

Pulse is a premium music streaming application built with Flutter, powered by YouTube Music. It offers a seamless, immersive listening experience with features like background playback, crossfading, offline downloads, and cloud synchronization via Firebase.

## Features

- **YouTube Music Integration:** Access a vast library of music, playlists, and artists directly from YouTube Music.
- **Advanced Audio Playback:** High-quality playback powered by `just_audio` and `audio_service`, featuring seamless background play and lock screen controls.
- **Crossfade Support:** Smooth transitions between tracks using a custom crossfade engine.
- **Offline Downloads:** Download your favorite tracks for offline listening using local storage (`sqflite`).
- **Cloud Synchronization:** Sync your playlists, favorites, and settings across devices using Firebase Firestore and Authentication.
- **Modern UI/UX:** A sleek, dark-themed user interface utilizing Material Design, Lucide icons, and immersive system UI overlays.
- **State Management:** Robust and scalable state management using Riverpod.
- **Deep Linking & Routing:** Advanced routing capabilities using GoRouter.

## Tech Stack

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.11.0)
- **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Routing:** GoRouter (`go_router`)
- **Backend/BaaS:** Firebase (Auth, Firestore, Google Sign-In)
- **Audio Engine:** `just_audio`, `audio_service`
- **Networking/API:** `dio`, `youtube_explode_dart` (v2.5.3)
- **Local Storage:** `sqflite`, `shared_preferences`, `path_provider`
- **UI Components:** `cached_network_image`, `shimmer`, `google_fonts`, `lucide_icons`

## Project Structure

The project follows a feature-based architecture combined with core utilities:

```text
lib/
├── core/         # Core utilities, constants, theme, and routing setup
├── data/         # Data layer (API clients, local database, models)
├── providers/    # Riverpod state providers (Auth, Audio, Settings, etc.)
├── screens/      # UI screens organized by feature (Home, Player, Library, Search, etc.)
├── services/     # Core services (Audio Handler, YouTube Music Parser, Crossfade Engine)
├── widgets/      # Reusable UI widgets
└── main.dart     # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (v3.11.0 or higher)
- Dart SDK
- Firebase project setup (for Auth and Firestore)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd Pulse
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup:**
   - Create a Firebase project.
   - Configure Android and iOS apps in your Firebase console.
   - Ensure you have `firebase_options.dart` generated in `lib/` using the FlutterFire CLI.

4. **Run the app:**
   ```bash
   flutter run
   ```

## Known Issues / Notes
- The project is pinned to `youtube_explode_dart: 2.5.3` because v3.x requires the Deno runtime, which is not available natively on Android. v2.5.3 provides the built-in Dart JSEngine needed for extracting streams.

