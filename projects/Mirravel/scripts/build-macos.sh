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
osacompile -o "$stage/Mirravel.app" "$project/Mirravel.applescript"
# Refuse a package that cannot run natively on both supported Mac architectures.
/usr/bin/lipo -verify_arch x86_64 arm64 "$stage/Mirravel.app/Contents/MacOS/applet"
resources="$stage/Mirravel.app/Contents/Resources"
cp "$project/Mirravel.command" "$project/core.sh" "$project/Anleitung.txt" "$project/README.md" "$project/AUTHORS.md" "$project/LICENSE" "$resources/"
chmod 755 "$resources/Mirravel.command" "$resources/core.sh"
info="$stage/Mirravel.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString 0.2.1' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleShortVersionString string 0.2.1' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleVersion string 4' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 4' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier io.github.pwnedg0blin.Mirravel' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string io.github.pwnedg0blin.Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleName Mirravel' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleName string Mirravel' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string Mirravel Beta' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName Mirravel Beta' "$info"
/usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 15.0' "$info" || /usr/libexec/PlistBuddy -c 'Set :LSMinimumSystemVersion 15.0' "$info"
/usr/libexec/PlistBuddy -c 'Add :NSHumanReadableCopyright string Copyright (c) 2026 PwnedG0blin' "$info" || /usr/libexec/PlistBuddy -c 'Set :NSHumanReadableCopyright Copyright (c) 2026 PwnedG0blin' "$info"
codesign --force --sign - "$stage/Mirravel.app"
codesign --verify --strict "$stage/Mirravel.app"
cp "$project/Anleitung.txt" "$project/LICENSE" "$stage/"
ln -s /Applications "$stage/Applications"
hdiutil create -volname 'Mirravel 0.2.1 Beta' -srcfolder "$stage" -ov -format UDZO "$output/Mirravel-0.2.1-Beta-Mac.dmg"
hdiutil verify "$output/Mirravel-0.2.1-Beta-Mac.dmg"
echo "DMG erstellt: $output/Mirravel-0.2.1-Beta-Mac.dmg"
echo 'Ad-hoc signierte Beta, nicht von Apple notarisiert. Keine Systemeinstellungen wurden vom Build geändert.'

