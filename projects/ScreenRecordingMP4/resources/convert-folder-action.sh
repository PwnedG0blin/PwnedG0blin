#!/bin/bash
set -u
source_path="$1"
base="$HOME/Library/Application Support/ScreenRecordingMP4"
log="$base/folder-action.log"
mkdir -p "$base"
write_log() { echo "$(date '+%F %T') $*" >> "$log"; }
[ -f "$source_path" ] || exit 0
case "$source_path" in *.mov|*.MOV) ;; *) exit 0 ;; esac
case "$source_path" in "$HOME/Desktop/"*) ;; *) exit 0 ;; esac
ffmpeg="/opt/homebrew/bin/ffmpeg"; ffprobe="/opt/homebrew/bin/ffprobe"
[ -x "$ffmpeg" ] || ffmpeg="/usr/local/bin/ffmpeg"
[ -x "$ffprobe" ] || ffprobe="/usr/local/bin/ffprobe"
[ -x "$ffmpeg" ] && [ -x "$ffprobe" ] || { write_log "ERROR: FFmpeg missing"; exit 1; }
destination="$(dirname "$source_path")/$(basename "$source_path" | sed -E 's/\.[mM][oO][vV]$/.mp4/')"
[ ! -e "$destination" ] || { write_log "SKIP: destination exists"; exit 0; }
lock="$base/.lock-$(printf '%s' "$source_path" | shasum -a 256 | cut -d' ' -f1)"
mkdir "$lock" 2>/dev/null || exit 0
tmp="$destination.part.$$"
cleanup() { rm -f "$tmp"; rmdir "$lock" 2>/dev/null || true; }
trap cleanup EXIT
write_log "DETECTED: $(basename "$source_path")"
stable=0; last=-1; ready=0
for ((i=0;i<300;i++)); do
  [ -f "$source_path" ] || exit 0
  bytes="$(stat -f %z "$source_path" 2>/dev/null || echo 0)"
  if [ "$bytes" -gt 0 ] && [ "$bytes" = "$last" ] && ! /usr/sbin/lsof "$source_path" >/dev/null 2>&1; then
    stable=$((stable+1))
  else stable=0; fi
  last="$bytes"
  if [ "$stable" -ge 3 ]; then ready=1; break; fi
  sleep 2
done
[ "$ready" -eq 1 ] || { write_log "ERROR: recording not ready"; exit 1; }
codec="$("$ffprobe" -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$source_path" 2>/dev/null || true)"
write_log "CONVERTING: $(basename "$source_path")"
if [ "$codec" = h264 ]; then
  "$ffmpeg" -nostdin -hide_banner -loglevel error -y -i "$source_path" -map 0:v:0 -map 0:a? -c:v copy -c:a aac -movflags +faststart -f mp4 "$tmp" >>"$log" 2>&1 || { write_log "ERROR: ffmpeg"; exit 1; }
else
  "$ffmpeg" -nostdin -hide_banner -loglevel error -y -i "$source_path" -map 0:v:0 -map 0:a? -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -c:a aac -movflags +faststart -f mp4 "$tmp" >>"$log" 2>&1 || { write_log "ERROR: ffmpeg"; exit 1; }
fi
[ -s "$tmp" ] && "$ffprobe" -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$tmp" | grep -q . || { write_log "ERROR: invalid MP4"; exit 1; }
[ ! -e "$destination" ] || exit 1
mv -n "$tmp" "$destination"
[ -s "$destination" ] || exit 1
write_log "OK: $(basename "$destination")"
if [ -f "$base/delete-original-after-success.enabled" ]; then
  rm -f -- "$source_path" && write_log "DELETED MOV: $(basename "$source_path")"
fi
