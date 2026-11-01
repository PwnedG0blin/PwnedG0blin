# Mirravel 1.0.0 – reguläre Veröffentlichung

**Kostenlos · Open Source (MIT) · macOS 15+**

Mirravel bündelt iPhone-Mirroring-Diagnose, eine experimentelle EU-Konfiguration auf dem Mac sowie Sicherung und kontrollierte Rücknahme der eigenen Änderungen. Die bereits getestete Programmfunktion bleibt erhalten. Neu sind die reguläre Versionierung ohne Beta-Zusatz sowie das fertige Universal-App- und DMG-Paket mit dem **Mirror-Glass-Appsymbol**.

## Downloads

- **Mirravel-1.0.0-Mac.dmg** – empfohlen: öffnen und Mirravel.app nach Applications ziehen.
- **Mirravel-1.0.0-App.zip** – direkt entpackbare Universal-Mac-App.
- **Mirravel-1.0.0-Source.zip** – Quellcode der Veröffentlichung.
- **SHA256SUMS.txt** – SHA-256-Prüfsummen.

## Funktionen und Sicherheit

- Diagnose des lokalen Status; Terminal-Menü und Protokollansicht.
- Optionaler macOS-Patch erst nach ausdrücklicher Eingabe **TEST** und lokaler Administratorbestätigung.
- Sicherung und bedingte Rücknahme ausschließlich der drei vom Tool verwalteten Eligibility-Werte.
- Keine Telemetrie, kein automatischer Log-Upload und keine Deaktivierung von SIP.

## Voraussetzungen und Teststand

**Mac:** Apple Silicon oder Intel mit **T2 Security Chip**, macOS 15 oder neuer. **iPhone:** iOS 18 oder neuer; reguläre iPhone-Mirroring-Voraussetzungen gelten weiterhin.

Am **23. Oktober 2026** habe ich iPhone Mirroring aus der EU mit iOS 27.2 RC und macOS 27.2 RC erfolgreich getestet. Ein realer Intel-/T2-Gerätetest und die langfristige Stabilität auf anderen Systemversionen sind nicht nachgewiesen. Die regionale Konfiguration bleibt experimentell; Apple-Updates können die Funktion ändern. „Reguläre Veröffentlichung“ ist kein universelles Kompatibilitätsversprechen.

Die App ist **ad-hoc signiert und nicht Apple-notarisiert**. Bei Blockierung des Erststarts: **System Settings → Privacy & Security → Open Anyway**. Für den optionalen Patch benötigt Apples **Terminal** zusätzlich **Full Disk Access**. Bitte SIP nicht deaktivieren.

[Anleitung und Quellcode](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/Mirravel) · [Fehler melden](https://github.com/PwnedG0blin/PwnedG0blin/issues)

© 2026 PwnedG0blin · MIT-Lizenz
