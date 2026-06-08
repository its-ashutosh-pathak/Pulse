# Pulse

Pulse is a premium music streaming application built with Flutter, powered by YouTube Music. It offers a seamless, immersive listening experience with features like background playback, crossfading, offline downloads, and cloud synchronization via Firebase.

### What is Pulse?
Pulse is an open-source Android music client that brings together the massive catalog of YouTube Music with the personalized, synced experience of a premium music app. 

The name "Pulse" reflects its core philosophy: an alive, dynamic, and responsive music listening experience that feels modern, fluid, and meticulously designed.

### Why Pulse?
- **YouTube Music's catalog** — Access YouTube Music's vast library for streaming, including rare tracks, live performances, covers, and remixes.
- **No premium subscription required** — Stream audio ad-free in the background without needing a YouTube Music Premium account.
- **Cross-device Syncing** — Sign in with your Google account to securely sync your liked songs, custom playlists, recently played history, and listening stats across all your devices using Firebase.
- **Uncompromised Aesthetics** — Built with modern design principles: glassmorphism, dynamic accent colors, smooth micro-animations, and a completely ad-free, clutter-free environment.

## Features

- **YouTube Music Integration:** Access a vast library of music, playlists, and artists directly from YouTube Music.
- **Advanced Audio Playback:** High-quality playback powered by `just_audio` and `audio_service`, featuring seamless background play and native lock screen controls.
- **Network Dropout Resilience:** Automatically skips unplayable tracks without freezing the app when losing signal.
- **Crossfade Support:** Smooth transitions between tracks using a custom crossfade engine.
- **Live Lyrics:** Real-time synced lyrics powered by LRCLIB, featuring a custom fallback mechanism to handle messy metadata.
- **Offline Downloads:** Download your favorite tracks and cached lyrics for 100% offline listening using local storage (`sqflite`).
- **Cloud Synchronization:** Bi-directional syncing of your playlists, favorites, and settings across devices using Firebase Firestore and Authentication.
- **Modern UI/UX:** A sleek, dark-themed user interface utilizing Material Design, Lucide icons, dynamic accent colors extracted from album art, and immersive system UI overlays.
- **State Management:** Robust and scalable state management using Riverpod.
- **Deep Linking & Routing:** Advanced routing capabilities using GoRouter.

## How it Works

**Authentication & Sync**
By logging in with Google, your personal library data is synced to a secure Firebase Firestore backend. Pulse employs a local-first caching strategy (via SQLite) so you have instant access to your library even when offline or in airplane mode. Background workers handle uploading changes (like adding a song to a playlist or liking a track) seamlessly when a connection is restored.

**Streaming Pipeline**
Pulse uses the `youtube_explode_dart` library to extract raw stream URLs directly from YouTube Music anonymously. Audio playback is handled by `just_audio` and `audio_service`, ensuring rock-solid background performance, buffering wake-locks to prevent Android from killing the app, and gapless playback.

## FAQ

**Q: Do I need YouTube Premium to use Pulse?**
No. Pulse bypasses ads and streams the audio directly from YouTube's public servers, functioning perfectly with or without a Premium account.

**Q: Can I import my Spotify or Apple Music playlists?**
We are currently working on a native, frictionless playlist importer. Due to API limitations on bulk data fetching, the feature is temporarily paused in v1.2.0 while we build a more robust backend solution.

**Q: Why isn't a song playing?**
If a song is age-restricted or region-locked by YouTube, it cannot be streamed anonymously. Pulse will attempt to skip up to 3 unplayable tracks automatically to keep the music going. 
*Fix for Android users:* Ensure that your phone's battery optimization for Pulse is set to "Unrestricted" (Settings → Apps → Pulse → Battery). Android aggressively kills background network tasks, which can prevent the next song from loading when your screen is locked.

**Q: Can my Google account get banned?**
Pulse uses official Firebase authentication for its own cloud-sync database. It does NOT log into your actual YouTube account to fetch streams. The streaming engine operates entirely anonymously via the InnerTube API. Therefore, your Google account is perfectly safe and disconnected from the streaming mechanism.

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

