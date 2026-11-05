# Mirravel 1.1.2 – Administrator-Aufruf korrigiert

Anwenden und Wiederherstellen öffnen jetzt gezielt den jeweiligen lokalen Befehl in Terminal. Dies ersetzt den Administrator-Aufruf über AppleScript, der trotz freigegebener Mirravel-App den Zugriff auf eligibility.plist verweigern konnte. Terminal benötigt **System Settings → Privacy & Security → Full Disk Access**. Das Passwort wird lokal von sudo abgefragt und nicht gespeichert. Die App aktualisiert die Diagnose bei erneuter Aktivierung. Ein geöffneter Terminal-Befehl wird nicht als erfolgreicher Patch ausgegeben.

**EU-Gerätetest am 5. November 2026:** PwnedG0blin hat iPhone Mirroring mit iOS 27.3 Developer Beta 1 und macOS 27.3 Developer Beta 1 (26C5035r), Apple Silicon arm64, nach Anwendung über Terminal erfolgreich getestet. Der korrigierte App-Start dieses Terminal-Wegs benötigt noch einen Gerätetest.

Enthält das helle DMG-Layout gemäß Encounty-Vorlage: App links, gestrichelter Pfeil, Applications rechts. Anleitung und Lizenz liegen in der App.

Ad-hoc signiert und nicht notarisiert. Bei Startblockierung: **System Settings → Privacy & Security → Open Anyway**.

## English

Apply and Restore now open their specific local command in Terminal, replacing the AppleScript administrator call that could be denied access even with Full Disk Access enabled for Mirravel. Grant **Terminal → Full Disk Access**. Password entry remains local to sudo. Opening Terminal is not reported as patch success.

**EU device test, November 5, 2026:** PwnedG0blin successfully used iPhone Mirroring with iOS 27.3 Developer Beta 1 and macOS 27.3 Developer Beta 1 (26C5035r) on Apple Silicon after applying through Terminal. The corrected app launch of this Terminal route still needs device verification.

Includes the selected light DMG layout. Ad-hoc signed, not notarized.
