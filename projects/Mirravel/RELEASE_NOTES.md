# Mirravel 1.1.0 – App-Fenster und Update-Prüfung

**Kostenlos · Open Source (MIT) · macOS 15+**

Mirravel hat jetzt ein eigenes macOS-Fenster mit Diagnose, Patch, Rücknahme und Start von iPhone Mirroring. Die Diagnose zeigt die drei lokalen Freigabewerte, erkennt Änderungen gegenüber dem zuletzt beobachteten macOS-Build und lässt sich ohne persönliche Daten kopieren. Unbekannte Eligibility-Strukturen sperren den Patch.

**Auf Updates prüfen** fragt auf Wunsch nach neueren stabilen Mirravel-Releases auf GitHub und öffnet die passende Release-Seite. Es wird nichts automatisch installiert.

## Downloads

- **Mirravel-1.1.0-Mac.dmg** – empfohlen: öffnen und Mirravel.app nach Applications ziehen.
- **Mirravel-1.1.0-App.zip** – direkt entpackbare Universal-Mac-App.
- **Mirravel-1.1.0-Source.zip** – Quellcode der Veröffentlichung.
- **SHA256SUMS.txt** – SHA-256-Prüfsummen.

## Funktionen und Sicherheit

- Das Kommando-Menü bleibt als Alternative erhalten.
- Optionaler macOS-Patch erst nach Bestätigung und lokaler Administratorabfrage. Im Kommando-Menü gilt weiterhin die Eingabe **TEST**.
- Sicherung und bedingte Rücknahme ausschließlich der drei vom Tool verwalteten Eligibility-Werte.
- Keine Telemetrie, kein automatischer Log-Upload und keine Deaktivierung von SIP.

## Voraussetzungen und Teststand

**Mac:** Apple Silicon oder Intel mit **T2 Security Chip**, macOS 15 oder neuer. **iPhone:** iOS 18 oder neuer; reguläre iPhone-Mirroring-Voraussetzungen gelten weiterhin.

Am **23. Oktober 2026** habe ich iPhone Mirroring aus der EU mit iOS 27.2 RC und macOS 27.2 RC erfolgreich getestet. Ein realer Intel-/T2-Gerätetest und die langfristige Stabilität auf anderen Systemversionen sind nicht nachgewiesen. Die regionale Konfiguration bleibt experimentell; Apple-Updates können die Funktion ändern. Dieser Gerätetest gilt für die bisherige Patch-Funktion. Das neue App-Fenster und iOS/macOS 27.3 Developer Beta 1 sind noch nicht im Zusammenspiel auf Geräten verifiziert.

Die App ist **ad-hoc signiert und nicht Apple-notarisiert**. Bei Blockierung des Erststarts: **System Settings → Privacy & Security → Open Anyway**. Für den optionalen Patch benötigt **Mirravel.app** zusätzlich **Full Disk Access**. Bitte SIP nicht deaktivieren.

[Anleitung und Quellcode](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/Mirravel) · [Fehler melden](https://github.com/PwnedG0blin/PwnedG0blin/issues)

© 2026 PwnedG0blin · MIT-Lizenz
