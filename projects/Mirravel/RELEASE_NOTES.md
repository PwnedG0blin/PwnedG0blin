# Mirravel 1.1.3 – bestätigtes DMG-Layout

Das Installationsfenster entspricht jetzt der gewählten Vorlage: heller Hintergrund, Mirravel-App links, gestrichelter Pfeil und Applications rechts. PwnedG0blin hat die Darstellung mit DMG Test 1 am 5. November 2026 auf seinem Mac bestätigt. Finder speichert das Layout beim Paketbau; Hintergrund und Symbolpositionen stammen aus der getesteten Vorlage.

Die Terminal-Korrektur aus 1.1.2 bleibt enthalten: Anwenden und Wiederherstellen öffnen den jeweiligen lokalen Befehl in Terminal. Terminal benötigt **System Settings → Privacy & Security → Full Disk Access**. Passwörter werden lokal von sudo abgefragt und nicht gespeichert.

**Erfolgreicher EU-Gerätetest durch PwnedG0blin am 5. November 2026:** iPhone Mirroring funktioniert nach Anwendung über Terminal mit iOS 27.3 Developer Beta 1 und macOS 27.3 Developer Beta 1 (macOS 26C5035r, arm64). Das bestätigt die Verbindung und Patch-Funktion; der korrigierte Start des Terminal-Befehls über die App ist separat zu prüfen.

Die App ist ad-hoc signiert und nicht notarisiert. Bei Startblockierung: **System Settings → Privacy & Security → Open Anyway**.

## English

The DMG now follows the selected layout: light background, Mirravel app on the left, a dashed arrow and Applications on the right. PwnedG0blin confirmed the appearance on his Mac using DMG Test 1 on November 5, 2026.

Includes the Terminal fix from 1.1.2. Apply and Restore open their respective local commands in Terminal, which requires **Full Disk Access**.

Successful EU device test reported by PwnedG0blin on November 5, 2026: iPhone Mirroring works with iOS/macOS 27.3 Developer Beta 1 (macOS 26C5035r, arm64) after applying the patch through Terminal. Launching that Terminal command from the updated app remains a separate verification step.

Ad-hoc signed, not notarized. If blocked, use **System Settings → Privacy & Security → Open Anyway**.
