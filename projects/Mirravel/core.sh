#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
# Original implementation, based on publicly documented os_eligibility keys.
# No downloads, telemetry, location spoofing, SIP changes or persistence.
set -euo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
umask 077
DOMAIN=OS_ELIGIBILITY_DOMAIN_IRON
KEYS=("$DOMAIN.os_eligibility_answer_t" "$DOMAIN.status.OS_ELIGIBILITY_INPUT_COUNTRY_BILLING" "$DOMAIN.status.OS_ELIGIBILITY_INPUT_COUNTRY_LOCATION")
PATCHED=(4 3 3)
STATE=/private/var/db/regionpilot
PLIST=
WORK=
SNAPSHOT=
LOCKED=0
TOUCHED=0
WAS_UCHG=0
SUCCESS=0

fail() { printf 'Abbruch: %s\n' "$*" >&2; exit 1; }
value() { /usr/bin/plutil -extract "$1" raw -o - "$2"; }
digest() { /usr/bin/shasum -a 256 "$1" | /usr/bin/awk '{print $1}'; }
find_plist() {
  local p
  for p in /private/var/db/os_eligibility/eligibility.plist /private/var/os_eligibility/eligibility.plist; do
    if [ -f "$p" ] && [ ! -L "$p" ]; then PLIST=$p; return; fi
  done
  fail 'Keine bekannte Eligibility-Datei gefunden. Es wird keine Datei angelegt.'
}
schema() {
  /usr/bin/plutil -lint "$PLIST" >/dev/null || fail 'Datei unlesbar. Terminal unter Privacy & Security > Full Disk Access erlauben; Terminal danach vollständig beenden und erneut öffnen.'
  local k v t
  for k in "${KEYS[@]}"; do
    t=$(/usr/bin/plutil -type "$k" "$PLIST") || fail 'Unbekanntes Dateiformat: erwarteter Mirroring-Schlüssel fehlt.'
    [ "$t" = integer ] || fail 'Unbekanntes Dateiformat: erwarteter Ganzzahlwert fehlt.'
    v=$(value "$k" "$PLIST") || fail 'Mirroring-Wert nicht lesbar.'
    case "$v" in 0|1|2|3|4) ;; *) fail 'Unbekannter Eligibility-Wert; keine Änderung.' ;; esac
  done
}
cleanup() {
  local code=$?
  trap - EXIT INT TERM HUP
  if [ "$TOUCHED" -eq 1 ] && [ "$SUCCESS" -eq 0 ] && [ -f "$SNAPSHOT" ]; then
    echo 'Schreibvorgang fehlgeschlagen; unmittelbare Sicherung wird zurückgespielt.' >&2
    if ! /bin/cat "$SNAPSHOT" > "$PLIST"; then
      printf 'Wiederherstellung fehlgeschlagen! Sicherung: %s\n' "$SNAPSHOT" >&2
      SNAPSHOT=
    fi
  fi
  if [ "$SUCCESS" -eq 0 ] && [ "$code" -eq 0 ] && [ "$TOUCHED" -eq 1 ]; then code=1; fi
  if [ "$WAS_UCHG" -eq 1 ]; then
    if ! /usr/bin/chflags uchg "$PLIST"; then
      echo 'Der ursprüngliche Dateischutz konnte nicht wieder gesetzt werden.' >&2
      code=1
    fi
  fi
  [ -z "$WORK" ] || /bin/rm -f "$WORK"
  [ -z "$SNAPSHOT" ] || /bin/rm -f "$SNAPSHOT"
  if [ "$LOCKED" -eq 1 ]; then /bin/rmdir "$STATE/lock"; fi
  exit "$code"
}
secure_state() {
  [ ! -L "$STATE" ] || fail 'Sicherungsordner ist ein Symlink.'
  if [ ! -e "$STATE" ]; then /bin/mkdir -m 700 "$STATE"; fi
  [ -d "$STATE" ] || fail 'Ungültiger Sicherungsordner.'
  [ "$(/usr/bin/stat -f '%u:%Lp' "$STATE")" = '0:700' ] || fail 'Sicherungsordner muss root gehören und Modus 700 haben.'
  /bin/mkdir -m 700 "$STATE/lock" || fail 'Ein weiterer Vorgang läuft oder wurde abgebrochen. Nicht parallel starten.'
  LOCKED=1
  trap cleanup EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM HUP
}
commit() {
  local flags
  /usr/bin/plutil -lint "$WORK" >/dev/null
  [ "$(digest "$PLIST")" = "$(digest "$SNAPSHOT")" ] || fail 'macOS hat die Datei während der Vorbereitung geändert. Erneut versuchen.'
  flags=$(/usr/bin/stat -f '%Sf' "$PLIST")
  case ",$flags," in *,schg,*|*,sappnd,*|*,uappnd,*) fail 'Unbekannter Dateischutz; keine Änderung.' ;; esac
  case ",$flags," in *,uchg,*) /usr/bin/chflags nouchg "$PLIST"; WAS_UCHG=1 ;; esac
  # Preserve the original inode, permissions, ACLs and extended attributes.
  # A last-moment eligibilityd write remains possible; no daemon is stopped.
  TOUCHED=1
  /bin/cat "$WORK" > "$PLIST"
  /usr/bin/plutil -lint "$PLIST" >/dev/null
}
prepare() {
  WORK=$(/usr/bin/mktemp "$STATE/work.XXXXXX")
  SNAPSHOT=$(/usr/bin/mktemp "$STATE/snapshot.XXXXXX")
  /bin/cat "$PLIST" > "$SNAPSHOT"
  /bin/cat "$SNAPSHOT" > "$WORK"
}
archive_previous_build() {
  local current_build=$1 saved_build archive name
  # Only called with the state lock held and the current plist schema checked.
  for name in original.plist build path active; do
    [ -f "$STATE/$name" ] && [ ! -L "$STATE/$name" ] || fail 'Die frühere Sicherung ist unvollständig. Keine Änderung.'
  done
  saved_build=$(/bin/cat "$STATE/build")
  [ -n "$saved_build" ] || fail 'Die Buildnummer der früheren Sicherung fehlt.'
  [ "$saved_build" != "$current_build" ] || fail 'Eine frühere Änderung für diesen macOS-Build ist gespeichert. Zuerst Menü 3 verwenden.'
  [ "$(/bin/cat "$STATE/path")" = "$PLIST" ] || fail 'Eligibility-Pfad hat sich geändert. Keine Änderung.'
  /usr/bin/plutil -lint "$STATE/original.plist" >/dev/null || fail 'Die frühere Sicherung ist nicht lesbar. Keine Änderung.'
  archive=$(/usr/bin/mktemp -d "$STATE/previous-build.XXXXXX")
  # Keep the old baseline before allowing prepare() to capture the new build.
  # A failed copy leaves the active marker intact and prevents any plist write.
  for name in original.plist build path active; do
    /bin/cp -p "$STATE/$name" "$archive/$name"
    /usr/bin/cmp -s "$STATE/$name" "$archive/$name" || fail 'Archivierung konnte nicht verifiziert werden. Keine Änderung.'
  done
  /bin/rm "$STATE/active"
  printf '\nmacOS-Build gewechselt: %s → %s\n' "$saved_build" "$current_build"
  printf 'Frühere Sicherung aufbewahrt: %s\n' "$archive"
  printf 'Der aktuelle macOS-Zustand wird vor dem neuen Patch separat gesichert.\n'
}
diagnose() {
  printf '\nmacOS: '; /usr/bin/sw_vers -productVersion
  printf 'Build: '; /usr/bin/sw_vers -buildVersion
  printf 'Architektur: '; /usr/bin/uname -m
  printf 'SIP: '; /usr/bin/csrutil status || true
  printf 'Mac-Sprachregion: '; /usr/bin/defaults read -g AppleLocale 2>/dev/null || true
  find_plist
  printf '\nDatei: %s\n' "$PLIST"
  if ! /usr/bin/plutil -lint "$PLIST" >/dev/null 2>&1; then
    echo 'Nicht lesbar. Terminal braucht Full Disk Access. Diagnose ändert nichts.'; return
  fi
  local k v
  for k in "${KEYS[@]}"; do
    v=$(value "$k" "$PLIST" 2>/dev/null) || v='nicht vorhanden'
    printf '%s = %s\n' "$k" "$v"
  done
  printf '\nAnswer 4 bedeutet lokal als berechtigt markiert, 2 lokal nicht berechtigt.\n'
  printf 'Das bestätigt keine erfolgreiche Verbindung zum iPhone.\n'
  printf 'iPhone-Store-Land und physischer Standort werden hier nicht ausgelesen.\n'
  printf 'Beta: dokumentierten Geräteteststand und bekannte Verbindungsprobleme in der Anleitung beachten.\n'
}
apply_patch() {
  find_plist; schema; secure_state
  local build answer i
  build=$(/usr/bin/sw_vers -buildVersion)
  answer=$(value "${KEYS[0]}" "$PLIST")
  if [ "$answer" = 4 ]; then
    echo 'Mac meldet bereits berechtigt. Kein Patch nötig; iPhone-Seite und Verbindungsprotokoll prüfen.'; return
  fi
  if [ -f "$STATE/active" ]; then
    archive_previous_build "$build"
  fi
  # Capture a consistent baseline. Never replace it with a later patched state.
  prepare
  /bin/cp "$SNAPSHOT" "$STATE/original.plist"
  printf '%s\n' "$build" > "$STATE/build"
  printf '%s\n' "$PLIST" > "$STATE/path"
  printf '%s\n' 'prepared' > "$STATE/active"
  for i in 0 1 2; do
    /usr/bin/plutil -replace "${KEYS[$i]}" -integer "${PATCHED[$i]}" "$WORK"
  done
  commit
  for i in 0 1 2; do
    [ "$(value "${KEYS[$i]}" "$PLIST")" = "${PATCHED[$i]}" ] || fail 'Verifikation fehlgeschlagen.'
  done
  SUCCESS=1
  printf '%s\n' 'applied' > "$STATE/active"
  printf '\nMac-Werte geschrieben und gelesen. iPhone Mirroring jetzt beenden und neu öffnen.\n'
  printf 'Das iPhone muss gesperrt in der Nähe liegen; WLAN/Bluetooth auf beiden Geräten an.\n'
  printf 'Erfolg ist erst eine tatsächlich funktionierende Verbindung.\n'
  printf 'Sicherung: %s/original.plist\n' "$STATE"
  printf 'macOS kann die Werte jederzeit neu berechnen. Kein Hintergrunddienst installiert.\n'
}
restore_patch() {
  find_plist; schema; secure_state
  [ -f "$STATE/active" ] || fail 'Keine eigene aktive Sicherung gefunden.'
  [ -f "$STATE/original.plist" ] && [ ! -L "$STATE/original.plist" ] || fail 'Sicherung fehlt.'
  [ "$(/bin/cat "$STATE/path")" = "$PLIST" ] || fail 'Eligibility-Pfad hat sich geändert. Kein altes Backup einspielen.'
  [ "$(/bin/cat "$STATE/build")" = "$(/usr/bin/sw_vers -buildVersion)" ] || fail 'macOS wurde seit dem Test aktualisiert. Alte Werte werden nicht über den neuen Build geschrieben. Details in der Anleitung.'
  local i current original
  # Abort if another writer changed any of the three keys to a third value.
  for i in 0 1 2; do
    current=$(value "${KEYS[$i]}" "$PLIST")
    original=$(value "${KEYS[$i]}" "$STATE/original.plist")
    [ "$current" = "${PATCHED[$i]}" ] || [ "$current" = "$original" ] || fail 'Werte zwischenzeitlich anderweitig geändert. Kein Überschreiben.'
  done
  prepare
  for i in 0 1 2; do
    original=$(value "${KEYS[$i]}" "$STATE/original.plist")
    case "$original" in 0|1|2|3|4) ;; *) fail 'Ungültige Sicherung.' ;; esac
    /usr/bin/plutil -replace "${KEYS[$i]}" -integer "$original" "$WORK"
  done
  commit
  for i in 0 1 2; do
    [ "$(value "${KEYS[$i]}" "$PLIST")" = "$(value "${KEYS[$i]}" "$STATE/original.plist")" ] || fail 'Verifikation der Wiederherstellung fehlgeschlagen.'
  done
  SUCCESS=1
  /bin/rm -f "$STATE/active"
  echo 'Die drei ursprünglichen Mirroring-Werte sind wiederhergestellt. Andere Bereiche wurden beibehalten.'
}
main() {
  [ "$(uname -s)" = Darwin ] || fail 'macOS erforderlich.'
  case "${1:-}" in
    diagnose) diagnose ;;
    apply|restore)
      [ "$(id -u)" -eq 0 ] || fail 'Über Mirravel mit Administratorrechten starten.'
      if [ "$1" = apply ]; then apply_patch; else restore_patch; fi ;;
    *) fail 'Interner Aufruf ungültig.' ;;
  esac
}
main "$@"

