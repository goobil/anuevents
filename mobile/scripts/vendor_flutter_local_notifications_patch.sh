#!/usr/bin/env bash
set -euo pipefail

# This script applies two minimal, local-only patches to
# the cached `flutter_local_notifications-12.0.4` plugin so
# the project can build reproducibly without manual pub-cache edits.
# It is intended as a temporary helper until the upstream package
# publishes a fix. It edits files under ~/.pub-cache.

PLUGIN_DIR="$HOME/.pub-cache/hosted/pub.dev/flutter_local_notifications-12.0.4"

if [ ! -d "$PLUGIN_DIR" ]; then
  echo "Plugin directory not found: $PLUGIN_DIR"
  echo "Run 'flutter pub get' in the mobile folder first, then re-run this script."
  exit 1
fi

backup() {
  local src="$1"
  if [ -f "$src" ]; then
    local bak="${src}.bak-$(date +%Y%m%d%H%M%S)"
    cp -p "$src" "$bak"
    echo "Backed up $src -> $bak"
  fi
}

echo "Applying patches to: $PLUGIN_DIR"

# 1) Ensure android/build.gradle contains a namespace declaration
GRADLE_FILE="$PLUGIN_DIR/android/build.gradle"
if [ -f "$GRADLE_FILE" ]; then
  if ! grep -q "^\s*namespace\s*\"com.dexterous.flutterlocalnotifications\"" "$GRADLE_FILE"; then
    backup "$GRADLE_FILE"
    # Try to add namespace under the android { } block - place after 'android {' if found
    if grep -q "^\s*android\s*{" "$GRADLE_FILE"; then
      awk 'BEGIN{added=0} {print; if(!added && $0 ~ /\bandroid\b\s*\{/){print "    namespace \"com.dexterous.flutterlocalnotifications\""; added=1}}' "$GRADLE_FILE" > "$GRADLE_FILE.tmp" && mv "$GRADLE_FILE.tmp" "$GRADLE_FILE"
      echo "Patched namespace into $GRADLE_FILE"
    else
      echo "Could not find 'android {' block in $GRADLE_FILE; skipping namespace insertion"
    fi
  else
    echo "Namespace already present in $GRADLE_FILE"
  fi
else
  echo "Gradle file not found at $GRADLE_FILE; skipping"
fi

# 2) Fix ambiguous Java overload by casting null in bigLargeIcon(null) call
JAVA_FILE="$PLUGIN_DIR/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java"
if [ -f "$JAVA_FILE" ]; then
  if grep -q "bigLargeIcon(null)" "$JAVA_FILE"; then
    backup "$JAVA_FILE"
    sed "s/bigLargeIcon(null)/bigLargeIcon((android.graphics.Bitmap) null)/g" "$JAVA_FILE" > "$JAVA_FILE.tmp" && mv "$JAVA_FILE.tmp" "$JAVA_FILE"
    echo "Patched ambiguous bigLargeIcon(null) -> bigLargeIcon((Bitmap) null) in $JAVA_FILE"
  else
    echo "No bigLargeIcon(null) call found in $JAVA_FILE or already patched"
  fi
else
  echo "Java file not found at $JAVA_FILE; skipping"
fi

echo "Done. Please run 'flutter clean' and rebuild your project if needed."
