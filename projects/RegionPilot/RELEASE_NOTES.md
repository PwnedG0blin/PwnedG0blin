# RegionPilot 0.1 Beta

Entwickelt von **PwnedG0blin** · Copyright (c) 2026 PwnedG0blin.

Erste öffentliche Beta des experimentellen macOS-Helfers für iPhone Mirroring.
**RegionPilot ist ein vorläufiger Projektname.**

## Downloads

- **RegionPilot-0.1-Beta-Mac.dmg:** App nach Programme ziehen; die App startet ein lokales Terminal-Menü.
- **RegionPilot-0.1-Beta-Quellpaket.zip:** vollständige Quellen, Anleitung, Tests und lokaler DMG-Bau ohne Xcode.
- **SHA256SUMS.txt:** Prüfsummen der beiden Pakete.

## Enthalten

Diagnose ohne Schreibzugriff, ausdrücklich bestätigter Mac-Patch, Sicherung der Originaldatei, Rücknahme der drei eigenen Schlüssel und ein erweiterter lokaler Mac-Protokollfilter. Alle Schritte sind in der beiliegenden Anleitung und im Projekt-README beschrieben.

## Vor dem ersten Test

Zuerst Menü **1 – Diagnose** verwenden. Für einen Patch braucht Terminal **Festplattenvollzugriff** und einen vollständigen Neustart. Menü **2** verändert erst nach Eingabe **TEST** und lokaler `sudo`-Abfrage die Systemdatei. Menü **3** nimmt eigene Werte unter den dokumentierten Voraussetzungen zurück.

**Getestet laut Nutzerangabe vom 18.10.2026:** iOS 27.2 und die zum Testzeitpunkt aktuelle macOS-Developer-Beta. Eine genaue macOS-Buildnummer wurde für diese Veröffentlichung nicht neu angegeben.

**Experimentell:** In einem früheren manuellen Test wurde kurz ein Bild angezeigt; danach gab es Timeouts. Ein dauerhaft zuverlässiger Verbindungsaufbau ist damit nicht bestätigt. Eine lokale Antwort `4` ist kein erfolgreicher Verbindungstest. Die Beta verändert weder den iPhone-Standort noch dessen Regionsprüfung. Vor einem macOS-Update möglichst zurücknehmen; alte Backups werden nicht automatisch über neue Builds geschrieben.

Die App ist ad-hoc signiert, nicht Developer-ID-signiert und nicht notarisiert. macOS kann beim ersten Start eine gezielte Freigabe verlangen. Gatekeeper und SIP nicht global deaktivieren.

Tests mit simulierten Systemdateien und der macOS-Paketbau prüfen die Implementierung und Verpackung; sie ersetzen keinen Hardware-, TCC- oder Mirroring-Test.

[Ausführliche Anleitung und Quellcode](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/RegionPilot) · [Fehler melden](https://github.com/PwnedG0blin/PwnedG0blin/issues/new)
