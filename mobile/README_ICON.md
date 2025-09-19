iOS App Icon generation

Place your desired icon image at `mobile/assets/icon.png` (square PNG, >=1024x1024 recommended).

Then run from the `mobile/` directory:

```bash
# install dev deps
flutter pub get
# generate iOS app icons
flutter pub run flutter_launcher_icons:main
```

Notes:
- The pubspec.yaml includes a `flutter_icons` config that sets `ios: true` and `android: false`.
- The generator will create all necessary iOS icon sizes and update the Xcode asset catalog.
- For best results, use a 1024x1024 PNG with no rounded corners. Xcode adds the appropriate masks when needed.
