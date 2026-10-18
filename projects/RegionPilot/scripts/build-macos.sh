#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
set -euo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
project="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
[[ "$(uname -s)" == Darwin ]] || { echo 'Zum Erstellen wird macOS benötigt.' >&2; exit 1; }
output="${1:-$project/dist}"
mkdir -p "$output"
output="$(cd "$output" && pwd -P)"
stage="$(mktemp -d "$output/.RegionPilot-stage.XXXXXX")"
trap 'rm -rf -- "$stage"' EXIT
osacompile -o "$stage/RegionPilot.app" "$project/RegionPilot.applescript"
resources="$stage/RegionPilot.app/Contents/Resources"
cp "$project/RegionPilot.command" "$project/core.sh" "$project/Anleitung.txt" "$project/README.md" "$project/AUTHORS.md" "$project/LICENSE" "$resources/"
chmod 755 "$resources/RegionPilot.command" "$resources/core.sh"
info="$stage/RegionPilot.app/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString 0.1' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleShortVersionString string 0.1' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleVersion string 1' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleVersion 1' "$info"
/usr/libexec/PlistBuddy -c 'Set :CFBundleIdentifier io.github.pwnedg0blin.RegionPilot' "$info" || /usr/libexec/PlistBuddy -c 'Add :CFBundleIdentifier string io.github.pwnedg0blin.RegionPilot' "$info"
/usr/libexec/PlistBuddy -c 'Add :CFBundleDisplayName string RegionPilot Beta' "$info" || /usr/libexec/PlistBuddy -c 'Set :CFBundleDisplayName RegionPilot Beta' "$info"
/usr/libexec/PlistBuddy -c 'Add :LSMinimumSystemVersion string 15.0' "$info" || /usr/libexec/PlistBuddy -c 'Set :LSMinimumSystemVersion 15.0' "$info"
/usr/libexec/PlistBuddy -c 'Add :NSHumanReadableCopyright string Copyright (c) 2026 PwnedG0blin' "$info" || /usr/libexec/PlistBuddy -c 'Set :NSHumanReadableCopyright Copyright (c) 2026 PwnedG0blin' "$info"
codesign --force --sign - "$stage/RegionPilot.app"
codesign --verify --strict "$stage/RegionPilot.app"
cp "$project/Anleitung.txt" "$project/LICENSE" "$stage/"
ln -s /Applications "$stage/Applications"
hdiutil create -volname 'RegionPilot 0.1 Beta' -srcfolder "$stage" -ov -format UDZO "$output/RegionPilot-0.1-Beta-Mac.dmg"
hdiutil verify "$output/RegionPilot-0.1-Beta-Mac.dmg"
echo "DMG erstellt: $output/RegionPilot-0.1-Beta-Mac.dmg"
echo 'Ad-hoc signierte Beta, nicht von Apple notarisiert. Keine Systemeinstellungen wurden vom Build geändert.'
