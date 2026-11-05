#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
set -euo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
project="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
[[ "$(uname -s)" == Darwin ]] || { echo 'Zum Erstellen wird macOS benötigt.' >&2; exit 1; }
output="${1:-$project/dist}"
mkdir -p "$output"
output="$(cd "$output" && pwd -P)"
stage="$(mktemp -d "$output/.Mirravel-stage.XXXXXX")"
trap 'rm -rf -- "$stage"' EXIT
app="$stage/Mirravel.app"
resources="$app/Contents/Resources"
mkdir -p "$app/Contents/MacOS" "$resources"
sdk="$(xcrun --sdk macosx --show-sdk-path)"
for arch in arm64 x86_64; do
  xcrun swiftc -sdk "$sdk" -swift-version 5 -parse-as-library -O -target "$arch-apple-macos15.0" \
    "$project/app/Mirravel.swift" "$project/app/Release.swift" -o "$stage/Mirravel-$arch"
done
/usr/bin/lipo -create "$stage/Mirravel-arm64" "$stage/Mirravel-x86_64" -output "$app/Contents/MacOS/Mirravel"
/usr/bin/lipo "$app/Contents/MacOS/Mirravel" -verify_arch x86_64 arm64
rm "$stage/Mirravel-arm64" "$stage/Mirravel-x86_64"
cp "$project/Apply.command" "$project/Restore.command" "$project/Mirravel.command" "$project/core.sh" "$project/Anleitung.txt" "$project/README.md" "$project/AUTHORS.md" "$project/LICENSE" "$resources/"
chmod 755 "$resources/Apply.command" "$resources/Restore.command" "$resources/Mirravel.command" "$resources/core.sh"
info="$app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Add :CFBundleExecutable string Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundlePackageType string APPL' "$info"
/usr/libexec/PlistBuddy -c 'Add :NSHighResolutionCapable bool true' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString 1.1.3' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleShortVersionString string 1.1.3' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleVersion string 10' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 10' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier io.github.pwnedg0blin.Mirravel' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string io.github.pwnedg0blin.Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleName Mirravel' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleName string Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string Mirravel' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 15.0' "$info" || /usr/libexec/PlistBuddy -c 'Set :LSMinimumSystemVersion 15.0' "$info"
/usr/libexec/PlistBuddy -c 'Add :NSHumanReadableCopyright string Copyright (c) 2026 PwnedG0blin' "$info" || /usr/libexec/PlistBuddy -c 'Set :NSHumanReadableCopyright Copyright (c) 2026 PwnedG0blin' "$info"
# Build the selected Mirror Glass artwork into every standard macOS icon size.
icon_source="$project/assets/MirrorGlass.png"
[[ -f "$icon_source" ]] || { echo 'Mirravel icon source is missing.' >&2; exit 1; }
iconset="$stage/Mirravel.iconset"
mkdir "$iconset"
for size in 16 32 128 256 512; do
  /usr/bin/sips -z "$size" "$size" "$icon_source" --out "$iconset/icon_${size}x${size}.png" >/dev/null
  double=$((size * 2))
  /usr/bin/sips -z "$double" "$double" "$icon_source" --out "$iconset/icon_${size}x${size}@2x.png" >/dev/null
done
/usr/bin/iconutil -c icns "$iconset" -o "$resources/Mirravel.icns"
/bin/rm -rf -- "$iconset"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIconFile Mirravel.icns' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleIconFile string Mirravel.icns' "$info"
/usr/libexec/PlistBuddy -c 'Delete :CFBundleIconName' "$info" >/dev/null 2>&1 || true
codesign --force --sign - "$stage/Mirravel.app"
codesign --verify --strict "$stage/Mirravel.app"
/usr/bin/ditto -c -k --sequesterRsrc --keepParent "$stage/Mirravel.app" "$output/Mirravel-1.1.3-App.zip"
ln -s /Applications "$stage/Applications"
mkdir -p "$stage/.background"
python3 "$project/scripts/dmg-background.py" "$stage/.background/background.png"
layout_python="${MIRRAVEL_LAYOUT_PYTHON:-python3}"
rw="$output/.Mirravel-layout.dmg"
mountpoint="$stage/.mount"
# Keep the mountpoint outside the image content tree.
mountpoint="$(mktemp -d "$output/.Mirravel-mount.XXXXXX")"
attached=0
cleanup() {
  if [[ "$attached" == 1 ]]; then hdiutil detach "$mountpoint" -quiet || true; fi
  rm -rf -- "$stage" "$mountpoint"
  rm -f -- "$rw"
}
trap cleanup EXIT
hdiutil create -volname 'Mirravel 1.1.3' -srcfolder "$stage" -ov -format UDRW "$rw"
hdiutil attach -readwrite -nobrowse -mountpoint "$mountpoint" "$rw"
attached=1
/usr/bin/osascript "$project/scripts/finder-layout.applescript" "$mountpoint" configure
sync
hdiutil detach "$mountpoint" -quiet
attached=0
hdiutil convert "$rw" -format UDZO -o "$output/Mirravel-1.1.3-Mac.dmg"
hdiutil verify "$output/Mirravel-1.1.3-Mac.dmg"
echo "DMG erstellt: $output/Mirravel-1.1.3-Mac.dmg"
echo 'Ad-hoc signierte Version, nicht von Apple notarisiert. Keine Systemeinstellungen wurden vom Build geändert.'

