Vendor helper for flutter_local_notifications patch

This repository includes a small helper script that applies temporary,
local-only fixes to the cached `flutter_local_notifications-12.0.4` plugin
so contributors don't have to manually edit their pub-cache during local
development.

Files
- `vendor_flutter_local_notifications_patch.sh` — script that applies two
  minimal patches to the plugin in `~/.pub-cache/hosted/pub.dev/...`:
  - Adds an `namespace "com.dexterous.flutterlocalnotifications"` line to
    `android/build.gradle` if missing.
  - Replaces `bigLargeIcon(null)` with `bigLargeIcon((android.graphics.Bitmap) null)`
    in `FlutterLocalNotificationsPlugin.java` to avoid ambiguous overloads.

Usage
1) Ensure you have run `flutter pub get` in the `mobile/` folder.
2) Run the script:

```bash
cd mobile/scripts
./vendor_flutter_local_notifications_patch.sh
```

3) If the script reported changes, run `flutter clean` in `mobile/` and rebuild.

Notes and follow-up
- This is intended as a temporary measure. A better long-term approach is to:
  - Vendor a minimal copy of the plugin into `mobile/plugins/flutter_local_notifications/` and update `mobile/pubspec.yaml` to point to the local path (I can create that for you), or
  - Open a PR against the upstream `flutter_local_notifications` package and use the published fix.
