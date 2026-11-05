#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
set -euo pipefail
project="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
image="$project/dist/Mirravel-1.1.3-Mac.dmg"
work="$(mktemp -d "${TMPDIR:-/tmp}/Mirravel-verify.XXXXXX")"
mountpoint="/Volumes/Mirravel 1.1.3"
[[ ! -e "$mountpoint" ]] || { echo "Datenträger bereits eingehängt: $mountpoint" >&2; exit 1; }
attached=0
cleanup() {
  if [[ "$attached" == 1 ]]; then hdiutil detach "$mountpoint" >/dev/null; fi
  rm -rf -- "$work"
}
trap cleanup EXIT
hdiutil attach "$image" -readonly -nobrowse -mountpoint "$mountpoint"
attached=1
[[ ! -e "$mountpoint/Mirravel.iconset" ]]
[[ -s "$mountpoint/.background/background.png" ]]
[[ -s "$mountpoint/.DS_Store" ]]
[[ "$(readlink "$mountpoint/Applications")" == /Applications ]]
/usr/bin/osascript "$project/scripts/finder-layout.applescript" "$mountpoint" verify
app="$mountpoint/Mirravel.app"
codesign --verify --strict "$app"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")" == 1.1.3 ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Contents/Info.plist")" == io.github.pwnedg0blin.Mirravel ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleName' "$app/Contents/Info.plist")" == Mirravel ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIconFile' "$app/Contents/Info.plist")" == Mirravel.icns ]]
[[ -s "$app/Contents/Resources/Mirravel.icns" ]]
/usr/bin/iconutil -c iconset "$app/Contents/Resources/Mirravel.icns" -o "$work/Mirravel.iconset"
[[ -s "$work/Mirravel.iconset/icon_512x512@2x.png" ]]
[[ "$(/usr/bin/sips -g pixelWidth "$work/Mirravel.iconset/icon_512x512@2x.png" | /usr/bin/awk '/pixelWidth:/ {print $2}')" == 1024 ]]
[[ "$(/usr/bin/sips -g pixelHeight "$work/Mirravel.iconset/icon_512x512@2x.png" | /usr/bin/awk '/pixelHeight:/ {print $2}')" == 1024 ]]
[[ -x "$app/Contents/Resources/Mirravel.command" ]]
for file in Apply.command Restore.command Mirravel.command core.sh Anleitung.txt README.md AUTHORS.md LICENSE; do
  cmp "$project/$file" "$app/Contents/Resources/$file"
done
for shell_file in Apply.command Restore.command Mirravel.command core.sh; do
  bash -n "$app/Contents/Resources/$shell_file"
done
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist")" == Mirravel ]]
/usr/bin/lipo "$app/Contents/MacOS/Mirravel" -verify_arch x86_64 arm64
lipo -archs "$app/Contents/MacOS/Mirravel"
# Independently extract and verify the directly downloadable .app archive.
/usr/bin/ditto -x -k "$project/dist/Mirravel-1.1.3-App.zip" "$work/app-zip"
zip_app="$work/app-zip/Mirravel.app"
codesign --verify --strict "$zip_app"
/usr/bin/lipo "$zip_app/Contents/MacOS/Mirravel" -verify_arch x86_64 arm64
cmp "$app/Contents/Resources/Mirravel.icns" "$zip_app/Contents/Resources/Mirravel.icns"
cmp "$app/Contents/Resources/core.sh" "$zip_app/Contents/Resources/core.sh"
echo 'App-ZIP, Mirror-Glass-Icon, Ressourcen, Version, Signatur und DMG geprüft. Kein System-Patch ausgeführt.'

