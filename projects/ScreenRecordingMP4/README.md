# ClipShift

**Automatic MOV → MP4 for macOS / Bildschirmaufnahmen automatisch als MP4 speichern**

[Deutsch](README.de.md) · [English](README.en.md) · [Installer / Installationsskript](INSTALL.command) · [Uninstall / Deinstallation](UNINSTALL.command)

ClipShift is a free, local macOS folder action. When a new **.mov** file is added to your **Desktop**, ClipShift checks that recording is finished, converts it to a widely compatible MP4 using FFmpeg, and optionally deletes the original after successful verification.

ClipShift ist eine kostenlose, lokale macOS-Ordneraktion. Sobald eine neue **.mov**-Datei auf dem **Schreibtisch** erscheint, wartet ClipShift, bis die Aufnahme fertig ist, erstellt mit FFmpeg eine MP4-Datei und kann das Original anschließend löschen.

### Download / Installation
1. Download [INSTALL.command](INSTALL.command) and [UNINSTALL.command](UNINSTALL.command) if desired.
2. Use the macOS Terminal to install FFmpeg: `brew install ffmpeg` (Homebrew required).
3. Run `INSTALL.command`, choose **Deutsch** or **English**, then follow the on-screen steps in **Folder Actions Setup**.
4. Record a **new** video using the standard macOS Screenshot utility. Earlier MOV files are not converted automatically.

**Note:** macOS may warn about downloaded scripts. Review the source before running it. No application signing or notarization is provided. The public bilingual installer has not yet been verified in a fresh macOS installation; the original folder-action approach has been tested on one Mac.

**Wichtig:** Die öffentliche zweisprachige Installationsvariante wurde noch nicht auf einem frisch eingerichteten Mac getestet. Die zugrunde liegende Ordneraktion funktionierte im privaten Test. Die vorhandene Installation muss nicht ersetzt werden.

© PwnedG0blin. See the repository license if present; no additional license grant is asserted here.
