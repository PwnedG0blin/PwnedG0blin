# ClipShift

**Automatic MOV → MP4 for macOS / Bildschirmaufnahmen automatisch als MP4 speichern**

[**DMG-Beta / Download**](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/clipshift-v0.2.0-beta.1) · [Deutsch](README.de.md) · [English](README.en.md) · [Quellcode-Installer / Script](INSTALL.command) · [Uninstall / Deinstallation](UNINSTALL.command)

ClipShift is a free, local macOS folder action. When a new **.mov** file is added to your **Desktop**, ClipShift checks that recording is finished, converts it to a widely compatible MP4 using FFmpeg, and optionally deletes the original after successful verification.

ClipShift ist eine kostenlose, lokale macOS-Ordneraktion. Sobald eine neue **.mov**-Datei auf dem **Schreibtisch** erscheint, wartet ClipShift, bis die Aufnahme fertig ist, erstellt mit FFmpeg eine MP4-Datei und kann das Original anschließend löschen.

### Download / Installation
1. Download the [ClipShift DMG public beta](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/clipshift-v0.2.0-beta.1) and drag ClipShift.app to Applications.
2. Open the app and click **Installieren** or **Install**. macOS may request permission to configure Folder Actions.
3. If automatic setup fails, attach MP4-bei-neuer-MOV.scpt manually in **Folder Actions Setup**. The separate add-new-item alert script should be disabled to avoid prompts.

**Script alternative:** [INSTALL.command](INSTALL.command) and [UNINSTALL.command](UNINSTALL.command) are still available, with bilingual prompts.

Install FFmpeg separately via Homebrew: `brew install ffmpeg` (Homebrew required). Make a **new** screen recording to test. Existing recordings are not processed automatically.

**Note:** macOS may warn about downloaded scripts. Review the source before running it. The DMG app uses an ad-hoc signature and is **not Apple-notarized**. The public bilingual installer has not yet been verified in a fresh macOS installation; the original folder-action approach has been tested on one Mac.

**Wichtig:** Die öffentliche zweisprachige Installationsvariante wurde noch nicht auf einem frisch eingerichteten Mac getestet. Die zugrunde liegende Ordneraktion funktionierte im privaten Test. Die vorhandene Installation muss nicht ersetzt werden.

© PwnedG0blin. See the repository license if present; no additional license grant is asserted here.
