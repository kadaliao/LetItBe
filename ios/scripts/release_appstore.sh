#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROJECT="$ROOT_DIR/ios/LetItBeApp/LetItBeApp.xcodeproj"
SCHEME="LetItBeApp"
BUILD_DIR="$ROOT_DIR/ios/build"
VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$ROOT_DIR/ios/LetItBeApp/Info.plist")"
ARCHIVE_PATH="$BUILD_DIR/LetItBeApp-$VERSION.xcarchive"
EXPORT_PATH="$BUILD_DIR/export-appstore"
EXPORT_OPTIONS="$BUILD_DIR/ExportOptions-AppStore.plist"

mkdir -p "$BUILD_DIR"

if [[ ! -f "$EXPORT_OPTIONS" ]]; then
  cat > "$EXPORT_OPTIONS" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store-connect</string>
    <key>signingStyle</key>
    <string>automatic</string>
    <key>teamID</key>
    <string>HMDAVG9B8J</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
PLIST
fi

echo "[1/3] Archiving..."
xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ARCHIVE_PATH" \
  archive

echo "[2/3] Exporting ipa..."
rm -rf "$EXPORT_PATH"
xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS"

IPA_PATH=$(find "$EXPORT_PATH" -maxdepth 1 -name "*.ipa" | head -n 1)
if [[ -z "$IPA_PATH" ]]; then
  echo "No IPA produced. Check signing certificates/profiles." >&2
  exit 1
fi

echo "IPA ready: $IPA_PATH"

if [[ -n "${APPSTORE_API_KEY_ID:-}" && -n "${APPSTORE_API_ISSUER_ID:-}" && -n "${APPSTORE_API_P8_PATH:-}" ]]; then
  echo "[3/3] Uploading with App Store Connect API key..."
  xcrun altool --upload-app \
    --file "$IPA_PATH" \
    --api-key "$APPSTORE_API_KEY_ID" \
    --api-issuer "$APPSTORE_API_ISSUER_ID" \
    --p8-file-path "$APPSTORE_API_P8_PATH"
  echo "Upload complete."
else
  echo "[3/3] Skipped upload (missing API key env vars)."
  echo "Set APPSTORE_API_KEY_ID / APPSTORE_API_ISSUER_ID / APPSTORE_API_P8_PATH to enable CLI upload."
fi
