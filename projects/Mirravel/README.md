# Mirravel — iPhone Mirroring Diagnostics for Mac

[Website](https://pwnedg0blin.pages.dev/) · [Alle Projekte / All projects](https://pwnedg0blin.pages.dev/projekte) · [Unterstützen / Support](https://pwnedg0blin.pages.dev/support)

**Version 0.2.1 Beta** · [English](README.en.md)

**Experimenteller macOS-Helfer für iPhone Mirroring. Kostenlos und Open Source unter der MIT-Lizenz.**

Entwickelt von **PwnedG0blin**.

[Beta herunterladen](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/mirravel-v0.2.1-beta) · [Profil](https://github.com/PwnedG0blin) · [Fehler melden](https://github.com/PwnedG0blin/PwnedG0blin/issues/new)

## EU-Zweck und experimentelle Umgehung

Mirravel richtet sich an Nutzerinnen und Nutzer in der Europäischen Union und verfolgt das Ziel, Apples regionale Einschränkung für iPhone Mirroring experimentell zu umgehen. Dafür bietet es Diagnose und Änderungen auf der Mac-Seite mit Sicherung und Rücknahme eigener Änderungen. Am 23.10.2026 hat PwnedG0blin eine funktionierende iPhone-Mirroring-Verbindung aus der EU mit iOS 27.2 RC und macOS 27.2 RC bestätigt. Prüfungen auf dem iPhone und spätere Systemupdates können die Verbindung weiterhin beeinflussen.

## Was die Beta kann

- Lokale Mirroring-Berechtigung und Systemversion auslesen.
- Auf ausdrücklichen Wunsch drei vorhandene Werte der macOS-Eligibility-Datei ändern.
- Den Ausgangszustand vor der Änderung sichern und die drei eigenen Werte wiederherstellen.
- iPhone Mirroring, die passenden Datenschutzeinstellungen und ein lokales Mac-Protokoll öffnen.

**Die Beta ist kein Standort-Spoofer und kein vollständiger Regions-Freischalter.** Sie verändert nur die Mac-Seite. Das iPhone kann die Verbindung weiterhin ablehnen. Ein lokaler Wert `4` ist kein Beweis für eine erfolgreiche Mirroring-Sitzung.

## Voraussetzungen und Grenzen

### Apple Silicon und Intel mit T2

Die veröffentlichte **Mirravel 0.2.1 Beta ist eine Universal-App**. Das geprüfte App-Paket enthält `arm64` und `x86_64`; dieselbe DMG ist für beide Mac-Typen vorgesehen.

| Mac | Architektur | Hardware-Voraussetzung |
| :--- | :--- | :--- |
| Apple Silicon | `arm64` | Mac mit Apple-Chip |
| Intel | `x86_64` | Eingebauter **Apple T2 Security Chip** erforderlich |

Für beide gelten **macOS Sequoia 15 oder neuer** und ein **iPhone mit iOS 18 oder neuer**. Intel-Macs ohne T2-Chip gehören nicht zu Apples unterstützten Geräten für iPhone Mirroring.

**Teststand:** Die beiden Architekturen wurden im [Paket-Build der veröffentlichten Beta](https://github.com/PwnedG0blin/PwnedG0blin/actions/runs/39943764031) nachgewiesen. Ein echter Mirroring-Gerätetest auf Intel/T2 wurde bislang nicht gemeldet. Die experimentelle Regionskonfiguration ist damit auf Intel noch nicht als funktionierend bestätigt.

Für iPhone Mirroring nennt Apple einen Mac mit Apple Silicon oder T2-Chip, macOS 15 oder neuer und ein iPhone mit iOS 18 oder neuer. Beide Geräte müssen denselben Apple Account mit Zwei-Faktor-Authentifizierung verwenden, WLAN und Bluetooth müssen eingeschaltet sein und das iPhone muss gesperrt in der Nähe liegen. AirPlay, Sidecar und Internetfreigabe am Mac sollen währenddessen nicht aktiv sein. [Apple-Anleitung](https://support.apple.com/en-euro/120421).

Apple führt iPhone Mirroring weiterhin als in der EU nicht verfügbar (Quellenprüfung: 18.10.2026). Diese Beta ist ein experimenteller Eingriff in eine undokumentierte macOS-Systemdatenbank, keine von Apple unterstützte Funktion.

**Erfolgreicher Gerätetest durch PwnedG0blin am 23.10.2026: iOS 27.2 RC und macOS 27.2 RC.** Der Test fand aus der Europäischen Union statt. Nach erneuter Anwendung des Mac-Patches wurde eine funktionierende iPhone-Mirroring-Verbindung bestätigt. Die genauen RC-Buildnummern wurden für diesen Test nicht angegeben.

**Testumfang:** Der aktuelle Gerätetest bestätigt den erfolgreichen Verbindungsaufbau mit beiden 27.2-RCs. Langzeitstabilität und andere Geräte- oder Versionskombinationen wurden damit nicht geprüft. In früheren Betas waren Verbindungs-Timeouts aufgetreten.

## Download und erster Start

1. Auf der [Beta-Seite](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/mirravel-v0.2.1-beta) unter **Assets** `Mirravel-0.2.1-Beta-Mac.dmg` laden.
2. DMG öffnen und **Mirravel.app** nach **Programme / Applications** ziehen. Die Anleitung liegt ebenfalls im DMG.
3. Mirravel öffnen. **Anleitung** zeigt diese Hinweise; **Terminal-Menü** startet das lokale Menü.
4. Im Terminal zuerst **1 – Diagnose** wählen. Dabei werden keine Systemeinstellungen geändert und keine Administratorrechte angefordert.

### Beim ersten Start in macOS freigeben

Diese Beta ist ad-hoc signiert und nicht notarisiert. macOS kann deshalb **„Mirravel.app was blocked to protect your Mac“** anzeigen.

1. Nach dem Kopieren nach **Applications** einmal versuchen, **Mirravel.app** zu öffnen.
2. **System Settings → Privacy & Security** öffnen und zum Abschnitt **Security** scrollen.
3. Neben der Meldung zu **Mirravel.app** auf **Open Anyway** klicken – genau dieser Schalter ist für die Freigabe vorgesehen.
4. Die lokale macOS-Abfrage bestätigen und Mirravel erneut öffnen; falls angeboten, **Open** wählen.

Diese App-Freigabe ist ein eigener Schritt. Für den experimentellen Patch benötigt **Terminal** zusätzlich **Full Disk Access**, wie im nächsten Abschnitt beschrieben. Gatekeeper oder SIP nicht systemweit deaktivieren.

Alternative ohne fertige App: `Mirravel-0.2.1-Beta-Source.zip` vollständig entpacken, alle Dateien zusammenlassen und `Mirravel.command` öffnen. Das Menü ist dasselbe. Nicht einzelne Dateien aus der GitHub-Vorschau herunterladen; vollständiges ZIP verwenden.

## Optional: experimentellen Mac-Patch testen

1. **Systemeinstellungen → Datenschutz & Sicherheit → Festplattenvollzugriff / Full Disk Access** öffnen. Menüpunkt **6** führt dorthin.
2. **Terminal.app** hinzufügen und einschalten. Bei Nutzung des mitgelieferten Launchers läuft der Helfer in Apples Terminal.
3. Terminal mit **⌘Q vollständig beenden**, danach Mirravel erneut starten. Eine schon offene Terminal-Sitzung übernimmt die Freigabe unter Umständen nicht.
4. iPhone Mirroring vollständig beenden. Im Menü **2** wählen, die Hinweise lesen und ausdrücklich **TEST** eingeben. Ohne diese Eingabe erfolgt kein Patch.
5. Das Mac-Administratorpasswort wird lokal von `sudo` abgefragt. Beim Tippen erscheinen keine Zeichen. Mirravel speichert oder überträgt das Passwort nicht.
6. Nach erfolgreicher Verifikation iPhone Mirroring erneut öffnen, beispielsweise über Menü **4**. iPhone sperren und neben den Mac legen.
7. Verbindung tatsächlich testen. Bei Timeout oder Regionsfehlern nicht annehmen, dass der Patch die Verbindung bereits repariert hat; siehe Fehlerdiagnose.

Kein Apple-Account-Wechsel, kein VPN und keine Deaktivierung von SIP sind Teil dieses Ablaufs.

## Was genau geändert und gesichert wird

Nur diese drei **vorhandenen Ganzzahlwerte** unter `OS_ELIGIBILITY_DOMAIN_IRON` werden verändert:

| Schlüssel | Testwert |
| :--- | :--- |
| `os_eligibility_answer_t` | `4` |
| `status.OS_ELIGIBILITY_INPUT_COUNTRY_BILLING` | `3` |
| `status.OS_ELIGIBILITY_INPUT_COUNTRY_LOCATION` | `3` |

Bekannte Dateipfade sind `/private/var/db/os_eligibility/eligibility.plist` und `/private/var/os_eligibility/eligibility.plist`. Bei fehlenden oder unbekannten Schlüsseln/Typen bricht das Programm ab.

Vor dem Schreiben wird die Ausgangsdatei unter **`/private/var/db/mirravel/original.plist`** gesichert. Der Ordner gehört `root` und hat Modus `700`. macOS-Build und Quellpfad werden ebenfalls gespeichert. Ein vorhandener `uchg`-Schreibschutz wird nur vorübergehend gelöst und anschließend wiederhergestellt; es wird kein neuer dauerhafter Schutz eingerichtet. Die Originaldatei behält ihren Inode, ihre Rechte, ACLs und erweiterten Attribute.

Die Sicherung liegt bewusst im geschützten Systembereich des Macs, auch wenn die App auf einer externen SSD liegt. Sie ist klein und enthält keine iPhone-Apps oder Nutzerdatenträger. Bei einer bestehenden Installation verwendet Mirravel den vorhandenen Sicherungsordner weiter. Werden zwei Sicherungsordner gefunden, bricht es vor einer Änderung ab. [Details zur Kompatibilität](COMPATIBILITY.md).

Es werden keine Dienste, Autostarts, geplanten Aufgaben, Profile, VPNs oder automatischen Dauer-Patches eingerichtet. Mirravel selbst tätigt keine Netzwerkanfragen; GitHub-Downloads und Apples Mirroring-Dienste sind davon getrennt.

## Eigene Änderung zurücknehmen

1. iPhone Mirroring beenden, Mirravel starten und **3 – Eigene Änderung zurücknehmen** wählen.
2. Die lokale Administratorabfrage bestätigen.
3. Das Programm setzt nur seine drei Schlüssel auf die gespeicherten Originalwerte zurück. Andere inzwischen geänderte Bereiche werden beibehalten.
4. Anschließend iPhone Mirroring erneut öffnen oder beenden, je nachdem, ob du es weiter nutzen möchtest.

Die Rücknahme wird verweigert, wenn Sicherung, Pfad oder macOS-Build nicht passen oder einer der drei Werte inzwischen einen anderen Zustand hat. **Vor einem geplanten macOS-Update möglichst zurücknehmen.** Nach einem Update keine komplette alte Eligibility-Datei über den neuen Zustand kopieren. Wenn der Mac nach dem Update wieder Antwort `2` meldet, kann Menü **2** den Patch erneut anwenden. Bei erkanntem Buildwechsel werden die vier bisherigen Sicherungsdateien zunächst unter `/private/var/db/mirravel/previous-build.XXXXXX` kopiert und byteweise geprüft. Erst danach sichert der Helfer den aktuellen macOS-Zustand als neue Ausgangsbasis. Alte Systemwerte werden nicht über den neuen Build geschrieben. Bei gleichem Build bleibt der bisherige Schutz gegen eine doppelte Anwendung aktiv.

## Fehlerdiagnose

| Anzeige / Problem | Nächster Schritt |
| :--- | :--- |
| `Operation not permitted` / Datei unlesbar | Festplattenvollzugriff für Terminal einschalten, Terminal vollständig beenden und neu starten. `sudo` allein ersetzt diese Freigabe nicht. |
| Fehlender Schlüssel, unbekannter Typ oder unbekannter Wert | Nicht erzwingen. Der macOS-Aufbau passt nicht zu dieser Beta; Systemversion und bereinigte Fehlermeldung melden. |
| Mac meldet bereits berechtigt / Antwort `4` | Es wird nicht erneut gepatcht. iPhone-Seite und Verbindungsaufbau prüfen. |
| `SFAuthenticationErrorCodeRegionLocked` im tatsächlichen Verbindungsprotokoll | Eine zusätzliche Ablehnung auf der iPhone-Seite ist möglich; die Beta verändert das iPhone nicht. |
| Timeout oder kurz sichtbarer Bildschirm | Kein Nachweis einer dauerhaft funktionierenden Freischaltung. Apples Verbindungsdiagnose und lokale Protokolle prüfen. |
| Frühere Änderung gespeichert / anderer Vorgang läuft | Keine parallelen Instanzen starten. Zuerst regulär zurücknehmen. Bei einem abgebrochenen Vorgang keine Sicherung oder Sperre blind löschen. |
| macOS-Build hat sich geändert und Antwort `2` | Menü **2** erneut verwenden: alte Sicherung archivieren, neuen Ausgangszustand sichern und Patch anwenden. Menü **3** spielt keine Werte eines alten Builds zurück. |

**Mac-Protokoll:** Zuerst einen fehlgeschlagenen Verbindungsversuch auslösen, danach Menü **5** wählen. Es zeigt die letzten fünf Minuten mit bis zu 160 Zeilen, einschließlich relevanter Verbindungs- und Aktivierungsmeldungen. Das ist nur das Mac-Protokoll. Die erklärenden Zeilen unter der Ausgabe sind keine gefundenen Fehlermeldungen. Keine Treffer beweisen weder Erfolg noch eine fehlende Regionssperre.

**iPhone-Protokoll:** Bei Bedarf das iPhone per USB verbinden, in der macOS-App **Konsole / Console** unter **Geräte / Devices** das iPhone auswählen und eine frische Aufnahme starten. Einen Mirroring-Versuch auslösen und anschließend stoppen. Nach `ScreenContinuityShell` oder `MediaContinuity` suchen. Falls Prozessnummern verwendet werden, die Nummer aus der aktuellen Aufnahme nehmen; sie kann sich nach jedem Neustart ändern. Zusätzliche Entwicklungs-/JIT-Tunnel oder VPNs können den Test beeinflussen, sind durch ihr bloßes Vorhandensein aber noch nicht als Ursache nachgewiesen.

Bei Timeouts empfiehlt Apple unter anderem Updates und Neustarts, die Prüfung von VPN-/Sicherheitsfiltern sowie das Zurücksetzen der Mirroring-Kopplung über die Einstellungen der Mirroring-App. Mirravel führt diese Schritte nicht automatisch aus. [Apple: Hilfe bei Verbindungsproblemen](https://support.apple.com/en-euro/120421).

Vor dem Teilen von Protokollen Namen, E-Mail-Adressen, Gerätekennungen und andere private Daten entfernen. Es gibt keinen automatischen Upload.

## Sicherung und Abbruchverhalten

Vor dem Schreiben vergleicht das Programm den aktuellen Dateiinhalt mit seinem unmittelbaren Snapshot. Bei erkannten Änderungen durch einen anderen Prozess wird nicht geschrieben. Bei einem Schreib- oder Verifikationsfehler versucht es, den unmittelbaren Snapshot zurückzuspielen. Falls auch das fehlschlägt, bleibt der Snapshot erhalten und sein Pfad wird angezeigt.

Eine gleichzeitige Änderung durch `eligibilityd` direkt nach der Prüfung lässt sich mit diesem Verfahren nicht vollständig ausschließen. Weder eine Stromunterbrechung noch ein Prozessabbruch mit `kill -9` kann vollständig abgefangen werden. Deshalb ist dies ausdrücklich eine Beta; vorhandene Sicherungen und Fehlermeldungen nicht vorschnell entfernen.

## Aus Quellcode bauen

Auf einem Mac das vollständige Quellpaket entpacken und **`DMG_erstellen.command`** öffnen. Alternativ:

```bash
/bin/bash scripts/build-macos.sh
```

Die fertige DMG liegt unter `dist/Mirravel-0.2.1-Beta-Mac.dmg`. AppleScript-Compiler, Signaturwerkzeuge und DMG-Werkzeuge gehören zu macOS; Xcode ist für diesen lokalen Paketbau nicht erforderlich. Projekt und temporäre Paketdateien bleiben im gewählten Ausgabeordner. Der Build führt keinen Patch aus.

Für die automatisierten Regressionstests wird Python 3 benötigt:

```bash
python3 -m unittest discover -s tests -v
```

Die Tests arbeiten ausschließlich mit temporären Plist-Fixtures und simulierten macOS-Werkzeugen. Sie ändern niemals die echte Eligibility-Datei. Der macOS-Build prüft zusätzlich AppleScript-Kompilierung, App-Ressourcen, DMG und Ad-hoc-Signatur. TCC/Festplattenvollzugriff, echte Administratorabfragen und eine komplette Mac-iPhone-Verbindung werden dadurch nicht getestet.

## Quellen und Einordnung

- [Apple: Voraussetzungen, Verfügbarkeit und Verbindungsdiagnose](https://support.apple.com/en-euro/120421)
- [nxm/iphone-mirroring-bypass](https://github.com/nxm/iphone-mirroring-bypass): öffentliche Dokumentation der drei Mac-Schlüssel und einer zusätzlichen iPhone-seitigen Ablehnung. Fremde Testergebnisse gelten nicht als Mirravel-Kompatibilitätsnachweis.
- [Pauli1Go/iphone-mirroring-eu-enabler](https://github.com/Pauli1Go/iphone-mirroring-eu-enabler): früherer Community-Ansatz.

Die Shell-Implementierung ist eigenständig. Es werden keine Fremdskripte heruntergeladen oder ausgeführt. Kein Apple-Produkt und keine Verbindung zu Apple.

## Kontakt und Unterstützung

Entwickelt von **[PwnedG0blin](https://github.com/PwnedG0blin)** · [X](https://x.com/PwnedG0blin) · [Patreon](https://www.patreon.com/cw/PwnedG0blinApp).

Urheberhinweis: **Copyright (c) 2026 PwnedG0blin** · [Entwicklung / AUTHORS](AUTHORS.md).

Lizenz: [MIT](LICENSE). Der Hinweis auf den experimentellen Beta-Status gehört zur Beschreibung dieser Veröffentlichung.


## Kompatibilität mit vorhandenen Sicherungen

App, Startdatei, Pakete, Workflow und aktuelle Projektseiten heißen einheitlich **Mirravel**. Die App verwendet die Bundle-ID `io.github.pwnedg0blin.Mirravel`. Neue Installationen sichern unter `/private/var/db/mirravel`; vorhandene ältere Sicherungen werden weiterhin erkannt und unter den bisherigen Prüfbedingungen verwendet. Die Rücknahme bleibt auf den passenden macOS-Build und die drei eigenen Werte begrenzt. [Upgrade-Hinweise](COMPATIBILITY.md).

