# Phase 1 rollout checklist

This document outlines a minimal rollout plan for Phase 1 (MVP) of AnuEvents. It assumes you have the Flutter SDK and Xcode/Android toolchain installed and that native Firebase config files are present locally (`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`).

## Goals
- Ship the core event creation and discovery flows.
- Verify poster upload (Firebase Storage), auth flows, and event submit flow work on device.
- Release internal test builds (Play internal & TestFlight), perform QA, then promote to production when ready.

## Pre-flight checks
- Ensure local Firebase config files are present and valid.
- Confirm App ID / bundle identifier matches store entries.
- Update `mobile/STORE_COPY.md` with final store text.
- Bump version in `mobile/pubspec.yaml`.

## Local verification commands

From the `mobile/` directory:

```bash
# fetch deps
flutter pub get
# iOS: install native pods
cd ios && pod install --repo-update && cd ..
# static analysis
flutter analyze
# run unit and widget tests (if provided)
flutter test
```

## Build artifacts

Android

```bash
# debug APK
flutter build apk --debug
# release AAB for Play Console
flutter build appbundle --release
```

iOS

- Open Xcode and select a real device or archive scheme. Or use CLI:

```bash
# create an iOS archive via xcodebuild (example outline)
# (recommend using Xcode Organizer for archives and uploads)
```

## Release flow

# Phase 1 rollout checklist

This document outlines a minimal rollout plan for Phase 1 (MVP) of AnuEvents. It assumes you have the Flutter SDK and Xcode/Android toolchain installed and that native Firebase config files are present locally (`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`).

## Goals

- Ship the core event creation and discovery flows.
- Verify poster upload (Firebase Storage), auth flows, and event submit flow work on device.
- Release internal test builds (Play internal & TestFlight), perform QA, then promote to production when ready.

## Pre-flight checks

- Ensure local Firebase config files are present and valid.
- Confirm App ID / bundle identifier matches store entries.
- Update `mobile/STORE_COPY.md` with final store text.
- Bump version in `mobile/pubspec.yaml`.

## Local verification commands

From the `mobile/` directory:

```bash
# fetch deps
flutter pub get
# iOS: install native pods
cd ios && pod install --repo-update && cd ..
# static analysis
flutter analyze
# run unit and widget tests (if provided)
flutter test
```

## Build artifacts

Android

```bash
# debug APK
flutter build apk --debug
# release AAB for Play Console
flutter build appbundle --release
```

iOS

- Open Xcode and select a real device or archive scheme. Or use CLI:

```bash
# create an iOS archive via xcodebuild (example outline)
# (recommend using Xcode Organizer for archives and uploads)
```

## Release flow

1. Create internal test builds:
   - Play Console: upload AAB to internal test track.
   - App Store: archive in Xcode, upload to TestFlight.
2. Invite testers and QA team.
3. Run smoke tests on devices (see QA checklist below).
4. Fix critical issues, iterate builds.
5. After sign-off, promote to production in Play Console and submit App Store release.

## QA smoke checklist (manual tests)

- Install and open app.
- Sign in (test account) and sign out flows.
- Create an event with required fields; attach poster image, confirm upload, and submit.
- Verify poster URL is saved and event appears in event list.
- Test cancel and retry behavior during uploads.
- Test push notifications flow if enabled (send test message).
- Basic navigation and accessibility sanity checks.

## Monitoring

- Monitor Play Console and App Store Connect for crash reports and telemetry.
- Use Firebase Crashlytics and Analytics to watch for regressions.

## Release notes template

- Title: Phase 1 (MVP) — Event creation & discovery
- Highlights:
  - Poster image upload with progress, cancel & retry
  - Event creation and ticketing flow
  - Basic notifications and attendee messaging
- Known issues: (list)

---

## Notes & references

- Store copy is centralized in `mobile/STORE_COPY.md`.
- If you need automation, consider using `fastlane` for iOS and Play Store uploads.
