#!/bin/bash
set -euo pipefail
echo "ClipShift — Deinstallation / Uninstall"
echo "1) Deutsch"
echo "2) English"
read -r -p "Sprache / Language [1/2]: " language
if [ "$language" = "2" ]; then
  echo "First detach MP4-bei-neuer-MOV.scpt from Desktop in Folder Actions Setup."
  read -r -p "Done? Continue? [y/N]: " yes
  [ "$yes" = y ] || [ "$yes" = Y ] || exit 0
else
  echo "Bitte zuerst MP4-bei-neuer-MOV.scpt in Folder Actions Setup vom Schreibtisch entfernen."
  read -r -p "Erledigt? Fortfahren? [j/N]: " yes
  [ "$yes" = j ] || [ "$yes" = J ] || exit 0
fi
base="$HOME/Library/Application Support/ScreenRecordingMP4"
script="$HOME/Library/Scripts/Folder Action Scripts/MP4-bei-neuer-MOV.scpt"
rm -f "$script"
rm -f "$base/convert-folder-action.sh" "$base/folder-action.applescript" "$base/delete-original-after-success.enabled"
echo "ClipShift files removed. / ClipShift-Dateien entfernt."
echo "FFmpeg and recordings remain untouched. / FFmpeg und Aufnahmen bleiben erhalten."
