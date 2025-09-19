Android app icons from provided density images

You provided density-specific images (hdpi, xhdpi, xxhdpi, mdpi). To use them as Android launcher icons, follow either Option A (manual copy) or Option B (use flutter_launcher_icons with a base image). Option A uses your provided images directly.

Option A — Manual copy (recommended since you already have density images):
1. Copy files into Android resource mipmap folders (from repo root):

# example commands (macOS / zsh)
cp /Users/kennethgoodwin/Downloads/ImageSets-2/android/drawable-mdpi/c8f8cdfb-4663-48dc-ad9a-eeafa76a8a63.jpg android/app/src/main/res/mipmap-mdpi/ic_launcher.png
cp /Users/kennethgoodwin/Downloads/ImageSets-2/android/drawable-hdpi/c8f8cdfb-4663-48dc-ad9a-eeafa76a8a63.jpg android/app/src/main/res/mipmap-hdpi/ic_launcher.png
cp /Users/kennethgoodwin/Downloads/ImageSets-2/android/drawable-xhdpi/c8f8cdfb-4663-48dc-ad9a-eeafa76a8a63.jpg android/app/src/main/res/mipmap-xhdpi/ic_launcher.png
cp /Users/kennethgoodwin/Downloads/ImageSets-2/android/drawable-xxhdpi/c8f8cdfb-4663-48dc-ad9a-eeafa76a8a63.jpg android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png

2. Also copy them to the adaptive icon folders if you use adaptive icons (ic_launcher_foreground/ic_launcher_background). Adjust names as needed.
3. Rebuild the Android app:

```bash
flutter clean
flutter build apk
```

Option B — Use flutter_launcher_icons (single base image):
1. Place a 1024x1024 PNG at `mobile/assets/icon.png`.
2. Run:

```bash
cd mobile
flutter pub get
flutter pub run flutter_launcher_icons:main
```

This will generate Android mipmap icons and iOS icons automatically.

Notes:
- Replace `ic_launcher.png` with `ic_launcher_round.png` if you need round icons too.
- Verify the files in `android/app/src/main/res/mipmap-*/` after copying.
