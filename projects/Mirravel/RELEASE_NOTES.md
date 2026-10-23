# Mirravel 0.2.0 Beta

Nach einem macOS-Update kann die lokale Mirroring-Berechtigung wieder auf `2` zurückgesetzt sein. Diese Version ermöglicht die erneute Anwendung des Mac-Patches, auch wenn eine Sicherung des vorherigen macOS-Builds vorhanden ist.

## Erfolgreich aus der EU mit iOS und macOS 27.2 RC getestet

**PwnedG0blin hat am 23.10.2026 aus der Europäischen Union eine funktionierende iPhone-Mirroring-Verbindung mit iOS 27.2 RC und macOS 27.2 RC bestätigt.** Nach dem Update war die Mac-Berechtigung wieder `2`; nach erneuter Anwendung der Korrektur funktionierte Mirroring wieder. Der Gerätetest erfolgte mit dem lokalen RegionPilot-0.2-Paket; dessen Korrektur ist in diese Mirravel-Version übernommen. Die genauen RC-Buildnummern wurden nicht angegeben.

## Änderungen

- Erkennt beim erneuten Anwenden einen anderen macOS-Build.
- Bewahrt die bisherige Sicherung in einem privaten `previous-build.XXXXXX`-Ordner auf und prüft die Kopien byteweise.
- Sichert den aktuellen macOS-Zustand als neue Ausgangsbasis, bevor die drei Mirroring-Werte geändert werden.
- Menü 3 verwendet weiterhin ausschließlich die Sicherung des aktuellen Builds. Alte Systemdateien werden nicht über einen neuen macOS-Build geschrieben.
- Bricht bei unvollständigen Sicherungen, geänderten Pfaden sowie Kopier- oder Vergleichsfehlern ab.
- Behält vorhandene RegionPilot-/Mirravel-Sicherungsordner und die Bundle-ID bei.

## Downloads und Installation

- **Mirravel-0.2.0-Beta-Mac.dmg:** öffnen und `Mirravel.app` nach `Applications` ziehen; eine ältere Mirravel-App ersetzen.
- **Mirravel-0.2.0-Beta-Quellpaket.zip:** vollständige Quellen, Anleitung, Tests und lokaler DMG-Bau ohne Xcode.
- **SHA256SUMS.txt:** Prüfsummen der beiden Pakete.

Nach dem Start Menü **1 – Diagnose** verwenden. Meldet der Mac nach einem Update wieder Antwort `2`, Menü **2** wählen, **TEST** eingeben und die lokale Administratorabfrage bestätigen. Anschließend iPhone Mirroring vollständig beenden und erneut öffnen. Terminal benötigt **Full Disk Access**.

Die Rücknahme bleibt über Menü **3** möglich. Diagnose, Sicherung und Rücknahme laufen lokal. Kostenlos und Open Source unter der MIT-Lizenz.

## First launch: allow Mirravel in macOS

This beta is ad-hoc signed and not notarized, so macOS may show **“Mirravel.app was blocked to protect your Mac.”**

1. After copying the app to **Applications**, try opening **Mirravel.app** once.
2. Open **System Settings → Privacy & Security** and scroll to **Security**.
3. Click **Open Anyway** next to the message about **Mirravel.app**.
4. Confirm the local macOS prompt, then open Mirravel again and choose **Open** if prompted.

Allowing the app to open is separate from granting **Terminal → Full Disk Access**, which is also required to apply the experimental patch.

## Testumfang

Der Gerätetest aus der EU bestätigt die erfolgreiche Verbindung mit den beiden 27.2-RCs. Langzeitstabilität und andere Geräte- oder Versionskombinationen sind damit nicht geprüft. Frühere Betatests hatten Timeouts gezeigt. Die Beta verändert nur die Mac-Seite; ein lokaler Wert `4` allein ist kein Verbindungstest.

Die automatisierten Prüfungen verwenden ausschließlich temporäre Systemdateien. Der macOS-Paketbau prüft zusätzlich AppleScript, App-Ressourcen, Ad-hoc-Signatur und DMG. Die App ist nicht Developer-ID-signiert und nicht notarisiert.

Entwickelt von **PwnedG0blin** · Copyright (c) 2026 PwnedG0blin.

[Anleitung und Quellcode](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/Mirravel) · [Fehler melden](https://github.com/PwnedG0blin/PwnedG0blin/issues/new)
