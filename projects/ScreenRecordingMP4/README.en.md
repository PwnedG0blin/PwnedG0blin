# ClipShift – English guide

ClipShift automatically converts **new MOV files on the macOS Desktop** to MP4. It uses **native macOS Folder Actions** with **FFmpeg**, not a periodic polling service. It runs locally without cloud services or a subscription.

## Requirements

- macOS with **Folder Actions Setup** and **AppleScript**
- FFmpeg and FFprobe via Homebrew: `brew install ffmpeg`
- Permission to access Desktop and the user's script directory

## ClipShift app setup (DMG)

1. Download the [ClipShift DMG public beta](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/clipshift-v0.2.0-beta.2).
2. Open the DMG and drag **ClipShift.app** into **Applications**.
3. Launch ClipShift and choose **Install**. The language follows your macOS preferences.
4. If the macOS permission dialog prevents automatic setup, open **Folder Actions Setup** and attach **MP4-bei-neuer-MOV.scpt** to Desktop manually.
5. FFmpeg must already be available: `brew install ffmpeg`.

**Security:** This beta is ad-hoc signed and **not notarized** by Apple. It has not yet been tested on a clean Mac. Do not bypass unknown safety prompts indiscriminately.

## Alternative: source script setup

1. Download [INSTALL.command](INSTALL.command). If macOS blocks the downloaded script, review its source and approve the specific file.
2. Run it in Terminal: `bash /path/to/INSTALL.command` (or double-click if executable).
3. Choose **2 – English**.
4. Choose whether the original MOV should be deleted **only after a successfully verified MP4 conversion**.
5. Open **Folder Actions Setup** using Spotlight. Enable **Enable Folder Actions**, add **Desktop** on the left, and attach **MP4-bei-neuer-MOV.scpt** on the right.
6. If **add - new item alert.scpt** is enabled, disable this *separate* default script to avoid unnecessary dialogs. Keep **MP4-bei-neuer-MOV.scpt enabled**.
7. Make a **new** test recording with the built-in macOS Screenshot tool.

## Behavior

- New MOV on Desktop triggers a folder action.
- ClipShift waits for the recording to finish writing.
- H.264 video is copied into MP4 when possible without re-encoding; other codecs are converted to H.264 for compatibility.
- MP4 is checked before optionally deleting the source.
- Other files and pre-existing recordings are ignored.
- Log: `~/Library/Application Support/ScreenRecordingMP4/folder-action.log`.

## Uninstall

Download [UNINSTALL.command](UNINSTALL.command). First detach **MP4-bei-neuer-MOV.scpt** from Desktop in **Folder Actions Setup**, then run the uninstall script. It retains **FFmpeg**, your recordings and unrelated folder actions.

## Notes

This is source code, not a signed/notarized macOS app. macOS may request Desktop and Folder Actions permissions. The public bilingual installer has not yet been verified on a clean Mac. Source MOV files are preserved if conversion fails.
