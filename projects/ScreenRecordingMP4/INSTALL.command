#!/bin/bash
set -euo pipefail

echo "Screen Recording → MP4 / Bildschirmaufnahme → MP4"
echo "1) Deutsch"
echo "2) English"
read -r -p "Sprache / Language [1/2]: " lang
case "$lang" in 2) lang=en ;; *) lang=de ;; esac
say() { if [ "$lang" = de ]; then printf '%s\n' "$1"; else printf '%s\n' "$2"; fi; }
fail() { say "$1" "$2"; exit 1; }

base="$HOME/Library/Application Support/ScreenRecordingMP4"
actions="$HOME/Library/Scripts/Folder Action Scripts"
name="MP4-bei-neuer-MOV.scpt"
mkdir -p "$base" "$actions"
ffmpeg="$(command -v ffmpeg || true)"
ffprobe="$(command -v ffprobe || true)"
if [ -z "$ffmpeg" ] || [ -z "$ffprobe" ]; then
  say "FFmpeg fehlt. Bitte zuerst 'brew install ffmpeg' ausführen." "FFmpeg is missing. Please run 'brew install ffmpeg' first."
  exit 1
fi

cat > "$base/convert-folder-action.sh" <<'CONVERTER'
#!/bin/bash
set -u
source_path="${1:-}"
base="$HOME/Library/Application Support/ScreenRecordingMP4"
log="$base/folder-action.log"
mkdir -p "$base"
write_log() { printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$log"; }
[ -f "$source_path" ] || exit 0
case "${source_path,,}" in *.mov) ;; *) exit 0 ;; esac
case "$source_path" in "$HOME/Desktop/"*) ;; *) exit 0 ;; esac
ffmpeg="$(command -v ffmpeg || echo /opt/homebrew/bin/ffmpeg)"
ffprobe="$(command -v ffprobe || echo /opt/homebrew/bin/ffprobe)"
[ -x "$ffmpeg" ] && [ -x "$ffprobe" ] || { write_log "ERROR: FFmpeg missing"; exit 1; }
file_name="$(basename "$source_path")"
destination="${source_path%.*}.mp4"
[ ! -e "$destination" ] || { write_log "SKIP: destination exists: $file_name"; exit 0; }
lock="$base/.lock-$(printf '%s' "$source_path" | shasum -a 256 | cut -d' ' -f1)"
mkdir "$lock" 2>/dev/null || exit 0
trap 'rmdir "$lock" 2>/dev/null || true' EXIT
write_log "DETECTED: $file_name"
# macOS may create the file before recording is finished. Wait for the
# recording app to close it, then require consecutive stable size samples.
stable=0
last=-1
ready=0
for ((i=0;i<300;i++)); do
  [ -f "$source_path" ] || exit 0
  bytes="$(stat -f %z "$source_path" 2>/dev/null || echo 0)"
  if [ "$bytes" -gt 0 ] && [ "$bytes" = "$last" ] && ! lsof "$source_path" >/dev/null 2>&1; then
    stable=$((stable+1))
  else
    stable=0
  fi
  last="$bytes"
  if [ "$stable" -ge 3 ]; then ready=1; break; fi
  sleep 2
done
[ "$ready" -eq 1 ] || { write_log "ERROR: file never became ready: $file_name"; exit 1; }
tmp="${source_path%.*}.mp4.part.$$"
trap 'rm -f "$tmp"; rmdir "$lock" 2>/dev/null || true' EXIT
codec="$("$ffprobe" -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$source_path" 2>/dev/null || true)"
write_log "CONVERTING: $file_name ($codec)"
if [ "$codec" = h264 ]; then
  "$ffmpeg" -nostdin -hide_banner -loglevel error -y -i "$source_path" -map 0:v:0 -map 0:a? -c:v copy -c:a aac -movflags +faststart -f mp4 "$tmp" >>"$log" 2>&1 || exit 1
else
  "$ffmpeg" -nostdin -hide_banner -loglevel error -y -i "$source_path" -map 0:v:0 -map 0:a? -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -c:a aac -movflags +faststart -f mp4 "$tmp" >>"$log" 2>&1 || exit 1
fi
[ -s "$tmp" ] && "$ffprobe" -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$tmp" | grep -q . || { write_log "ERROR: invalid MP4: $file_name"; exit 1; }
if [ -e "$destination" ]; then write_log "SKIP: destination appeared: $file_name"; exit 1; fi
mv -n "$tmp" "$destination"
[ -s "$destination" ] || { write_log "ERROR: destination missing: $file_name"; exit 1; }
write_log "OK: $(basename "$destination")"
if [ -f "$base/delete-original-after-success.enabled" ]; then
  rm -f -- "$source_path" && write_log "DELETED MOV: $file_name"
fi
CONVERTER
chmod 700 "$base/convert-folder-action.sh"

cat > "$base/folder-action.applescript" <<'APPLESCRIPT'
on adding folder items to this_folder after receiving added_items
  repeat with an_item in added_items
    try
      set filePath to POSIX path of an_item
      if filePath ends with ".mov" or filePath ends with ".MOV" then
        set scriptPath to (POSIX path of (path to home folder)) & "Library/Application Support/ScreenRecordingMP4/convert-folder-action.sh"
        do shell script "nohup /bin/bash " & quoted form of scriptPath & " " & quoted form of filePath & " >/dev/null 2>&1 </dev/null &"
      end if
    end try
  end repeat
end adding folder items to
APPLESCRIPT
/usr/bin/osacompile -o "$actions/$name" "$base/folder-action.applescript" || fail "AppleScript konnte nicht erstellt werden." "Could not compile AppleScript."
touch "$base/delete-original-after-success.enabled"
say "Installation abgeschlossen." "Installation completed."
say "Jetzt 'Folder Actions Setup' öffnen, Folder Actions aktivieren, Desktop wählen und MP4-bei-neuer-MOV.scpt zuweisen." "Now open 'Folder Actions Setup', enable Folder Actions, choose Desktop and attach MP4-bei-neuer-MOV.scpt."
say "Falls 'add - new item alert.scpt' aktiviert ist, dieses deaktivieren, damit die Nachfrage nicht erscheint." "If 'add - new item alert.scpt' is enabled, disable it to avoid the extra prompt."
say "Wichtig: Bereits bestehende MOV-Dateien werden nicht verarbeitet. Erst eine NEUE Testaufnahme machen." "Important: Existing MOV files are not processed. Make a NEW test recording."
