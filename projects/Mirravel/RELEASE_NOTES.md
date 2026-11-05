# Mirravel 1.1.3 – Finder-DMG-Darstellung

Finder schreibt die Installationsansicht jetzt selbst beim Paketbau. Anschließend wird die fertige, schreibgeschützte DMG erneut geöffnet und über Finder auf Hintergrundbild, Fenstergröße, Symbolgröße und Symbolpositionen geprüft. Die vorherige reine Prüfung der gespeicherten Layout-Datei hatte die abweichende Darstellung nicht erkannt.

Die Vorlage bleibt unverändert: heller Hintergrund, Mirravel links, gestrichelter Pfeil und Applications rechts. Die Darstellung auf dem Anwender-Mac muss noch bestätigt werden.

Die Terminal-Korrektur aus 1.1.2 bleibt erhalten. Terminal benötigt Full Disk Access.

EU-Gerätetest durch PwnedG0blin am 5. November 2026: iPhone Mirroring funktioniert nach Anwendung über Terminal mit iOS und macOS 27.3 Developer Beta 1 (macOS 26C5035r, arm64).

Ad-hoc signiert, nicht notarisiert. Bei Startblockierung: System Settings → Privacy & Security → Open Anyway.

## English

Finder now writes the DMG installation layout itself. The final read-only image is reopened and checked through Finder for its background picture, window size, icon size and icon positions. The prior stored-layout check did not catch the incorrect appearance.

The light reference layout is unchanged. Appearance on the user's Mac still needs confirmation.

Includes the Terminal fix from 1.1.2. Terminal requires Full Disk Access. Successful EU device test with iOS/macOS 27.3 Developer Beta 1 was reported by PwnedG0blin on November 5, 2026.
