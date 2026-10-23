#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
# Mirravel 0.2.0 Beta — local experimental iPhone Mirroring helper.
# Uses only tools shipped with macOS. Does not install a daemon.
set -u
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
HERE=$(cd -- "$(dirname -- "$0")" && pwd -P)
if [ "$(uname -s)" != Darwin ]; then
  echo 'Mirravel benötigt macOS.'; exit 1
fi
while :; do
  printf '\nMirravel 0.2.0 Beta · iPhone Mirroring\n\n'
  printf '1  Diagnose (nur lesen)\n2  Experimentellen Mac-Patch testen\n3  Eigene Änderung zurücknehmen\n4  iPhone Mirroring öffnen\n5  Verbindungsprotokoll anzeigen (letzte 5 Minuten)\n6  Systemeinstellungen: Full Disk Access\n0  Beenden\n\n'
  read -r -p 'Auswahl: ' choice || exit 0
  case "$choice" in
    1) /bin/bash "$HERE/core.sh" diagnose ;;
    2)
      printf '\nExperiment: Ändert drei Mirroring-Werte in einer macOS-Systemdatenbank.\n'
      printf 'Die ursprünglichen Werte werden vorher gesichert. SIP bleibt aktiviert.\n'
      printf 'Erfolgreicher Gerätetest: iOS 27.2 RC und macOS 27.2 RC (23.10.2026).\n'
      printf 'Nach macOS-Updates wird die frühere Sicherung vor dem neuen Versuch archiviert.\n'
      printf 'Kein US-Standort, kein VPN und keine Freischaltung anderer Funktionen.\n'
      printf 'Terminal braucht Full Disk Access; anschließend Terminal neu öffnen.\n'
      read -r -p 'Zum Testen TEST eingeben, sonst Enter: ' accept || exit 0
      if [ "$accept" = TEST ]; then
        /usr/bin/sudo /bin/bash "$HERE/core.sh" apply
      fi ;;
    3) /usr/bin/sudo /bin/bash "$HERE/core.sh" restore ;;
    4) /usr/bin/open '/System/Applications/iPhone Mirroring.app' ;;
    5)
      printf '\nJetztige Ausgabe nur lokal. Vor dem Teilen private Angaben entfernen.\n'
      /usr/bin/log show --last 5m --style compact --info --debug \
        --predicate '(process == "iPhone Mirroring" OR process == "replicatord" OR subsystem CONTAINS[c] "screensharing" OR subsystem CONTAINS[c] "MediaContinuity") AND subsystem != "com.apple.launchservices"' 2>&1 | /usr/bin/tail -n 160
      printf '\nDies ist nur das Mac-Protokoll, kein iPhone-Protokoll.\n'
      printf '\nRemote device / SFAuthenticationErrorCodeRegionLocked weist auf die iPhone-Seite hin.\n'
      printf 'Keine Treffer beweisen keine Freischaltung. Erst Verbindung versuchen, dann erneut lesen.\n' ;;
    6) /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles' ;;
    0) exit 0 ;;
    *) echo 'Bitte 0 bis 6 wählen.' ;;
  esac
done

