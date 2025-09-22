# Phase 1 Flutter scaffold

This folder contains a minimal Flutter app scaffold to start building Phase 1 (MVP) screens.

To run:

- Install Flutter SDK separately (not included in repo)
- From this folder: `flutter pub get` and `flutter run`

Firebase setup:

- The FlutterFire CLI generated `lib/firebase_options.dart` for this project. This file is safe to commit.
- Native Firebase config files (`google-services.json` for Android and `GoogleService-Info.plist` for iOS) are placed locally by the FlutterFire CLI at `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` respectively. These files are intentionally ignored by `.gitignore` to avoid leaking project credentials.

## Store copy

Canonical marketing copy (short and long) now lives in `STORE_COPY.md`. See `mobile/STORE_COPY.md` for short variants, Play Store long description, and suggested App Store text.
