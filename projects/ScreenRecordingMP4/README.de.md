# ClipShift – Anleitung (Deutsch)

ClipShift wandelt neue MOV-Dateien vom macOS-Schreibtisch automatisch in MP4 um, ohne den Schreibtisch alle paar Sekunden abzufragen. Es nutzt die **macOS-Ordneraktionen** und **FFmpeg**. Es läuft lokal, ohne Cloud und ohne Abo.

## Voraussetzungen

- macOS mit **Folder Actions Setup** und **AppleScript**
- FFmpeg und FFprobe über Homebrew: `brew install ffmpeg`
- Schreibrechte für den Schreibtisch und den Skriptordner

## Installation der ClipShift-App (DMG)

1. Die [ClipShift-DMG-Beta herunterladen](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/clipshift-v0.2.0-beta.1).
2. DMG öffnen und **ClipShift.app** in **Programme** ziehen.
3. ClipShift starten und **Installieren** wählen. Die App erkennt die Sprache über macOS.
4. Wenn die automatische Ordneraktions-Zuordnung wegen Berechtigungen scheitert: **Folder Actions Setup** öffnen und **MP4-bei-neuer-MOV.scpt** dem Schreibtisch zuweisen.
5. Für automatische Konvertierung neuer MOV-Dateien muss FFmpeg über Homebrew vorhanden sein: `brew install ffmpeg`.

**Hinweis:** Die App ist derzeit ad-hoc-signiert und nicht von Apple notarisiert. Diese Beta wurde noch nicht auf einem frischen Mac getestet. Kein Sicherheitsdialog sollte pauschal umgangen werden.

## Alternative: Quellcode-Installer

1. Lade [INSTALL.command](INSTALL.command) herunter. Falls macOS die Ausführung blockiert, prüfe den Inhalt und gib die Datei gezielt frei.
2. Starte die Datei per Terminal: `bash /Pfad/zu/INSTALL.command` (oder per Doppelklick, wenn ausführbar).
3. Wähle **1 – Deutsch**.
4. Wähle, ob die MOV-Datei **nur nach erfolgreicher MP4-Erstellung** gelöscht werden darf.
5. Öffne **Folder Actions Setup / Ordneraktionen konfigurieren** (über Spotlight), aktiviere **Enable Folder Actions**, füge links **Desktop/Schreibtisch** hinzu und weise rechts **MP4-bei-neuer-MOV.scpt** zu.
6. Falls **add - new item alert.scpt** aktiv ist, deaktiviere dieses *separate* Standardskript, um unnötige Bestätigungsfenster zu vermeiden. **MP4-bei-neuer-MOV.scpt muss aktiviert bleiben.**
7. Erstelle eine **neue** Test-Bildschirmaufnahme mit dem macOS-Screenshot-Tool.

## Funktionsweise

- Neue MOV-Datei auf dem Schreibtisch → Ordneraktion.
- ClipShift wartet auf eine stabil gespeicherte, nicht geöffnete Datei.
- H.264 wird nach Möglichkeit ohne erneute Videokodierung in MP4 übertragen; andere Codecs werden für Kompatibilität in H.264 konvertiert.
- Die MP4 wird geprüft, erst danach kann das MOV-Original gelöscht werden.
- Andere Dateien und alte Aufnahmen werden nicht automatisch verarbeitet.
- Protokoll: `~/Library/Application Support/ScreenRecordingMP4/folder-action.log`.

## Deinstallation

Lade [UNINSTALL.command](UNINSTALL.command) herunter. Entferne in **Folder Actions Setup** zuerst die Zuordnung **MP4-bei-neuer-MOV.scpt** zum Schreibtisch. Führe danach das Deinstallationsskript aus. Es belässt **FFmpeg**, deine Videos und andere Ordneraktionen.

## Hinweise

Dies ist ein Quelltext-Tool, keine signierte oder notarisierte App. macOS kann Berechtigungen für Ordneraktionen und den Schreibtisch anfordern. Der Code ist ein öffentliches zweisprachiges Installationspaket, das noch nicht auf einem frisch eingerichteten Mac getestet wurde. Bei einem Fehler bleibt das MOV-Original grundsätzlich erhalten.
