#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
set -euo pipefail
project="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"
image="$project/dist/Mirravel-0.1.1-Beta-Mac.dmg"
mountpoint="$(mktemp -d "${TMPDIR:-/tmp}/Mirravel-verify.XXXXXX")"
attached=0
cleanup() {
  if [[ "$attached" == 1 ]]; then hdiutil detach "$mountpoint" >/dev/null; fi
  rmdir "$mountpoint"
}
trap cleanup EXIT
hdiutil attach "$image" -readonly -nobrowse -mountpoint "$mountpoint"
attached=1
app="$mountpoint/Mirravel.app"
codesign --verify --strict "$app"
[[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")" == 0.1.1 ]]
[[ -x "$app/Contents/Resources/Mirravel.command" ]]
for file in Mirravel.command core.sh Anleitung.txt README.md AUTHORS.md LICENSE; do
  cmp "$project/$file" "$app/Contents/Resources/$file"
done
bash -n "$app/Contents/Resources/Mirravel.command" "$app/Contents/Resources/core.sh"
osadecompile "$app/Contents/Resources/Scripts/main.scpt" >/dev/null
lipo -archs "$app/Contents/MacOS/applet"
echo 'App-Ressourcen, Version, AppleScript, Signatur und gemountete DMG geprüft. Kein System-Patch ausgeführt.'
