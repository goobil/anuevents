# ANU Events — mobile (developer notes)

Short developer notes to help contributors run the mobile app locally on macOS.

## Quick start

1. Install Flutter and Xcode as usual for iOS development.
2. From the `mobile/` directory run:

```bash
flutter pub get
flutter analyze --no-pub
```

## Run on Android emulator

1. Start an Android emulator (e.g. `emulator-5554`).
2. Build & run:

```bash
flutter run -d emulator-5554
```

## Run on iOS device (development device)

1. Connect your iPhone via USB and unlock it.
2. If the phone prompts "Trust this computer?" tap Trust and enter the passcode.
3. Open Xcode → Window → Devices and Simulators → Devices and select the device.
   - If you see "Use for Development" click it (this mounts the Developer Disk Image).
   - If Xcode warns the device OS requires a newer Xcode, update Xcode to a matching version.
4. From the `mobile/` folder run:

```bash
flutter run -d <device-id>
# e.g. flutter run -d 00008020-001D09D13646002E -v
```

## Vendored plugin & local patch helper

We encountered an Android Gradle / plugin issue with `flutter_local_notifications` that required a small fix (adding `namespace` and disambiguating a Java overload) for reproducible builds. Two approaches are supported:

- Vendored local plugin (recommended for reproducibility):
  - `mobile/plugins/flutter_local_notifications/` contains a minimal vendored copy used by the project. No extra steps required after `flutter pub get`.

- Local pub-cache patch (alternative):
  - Run the helper script to apply the same minimal patches to your local pub-cache copy:

```bash
cd mobile/scripts
./vendor_flutter_local_notifications_patch.sh
```

After running the helper, run `flutter clean` and rebuild.

Note: These are temporary measures. When upstream releases a fixed version we should restore the hosted dependency.

## Firestore index

If you see runtime logs like:

```
The query requires an index. You can create it here: <Firebase Console URL>
```

Follow the provided URL to create the composite index in Firebase so queries used by the app return results.

## Phase 3: Play Console checklist (for later)

- Create a Google Play Developer account and payments profile.
- Create the Play app with package `com.goobil.anuevents_mobile`.
- Add the service account email used by the upload script to Play Console with Release Manager role.
- Ensure the Android Publisher API is enabled on the linked GCP project.
- Re-run `mobile/scripts/upload_to_play.py` to upload the AAB and assign a track (internal/testing/production).

---

If you want, I can open a PR with these changes and/or revert the vendored plugin later when upstream publishes a fix.
# anuevents_mobile

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
