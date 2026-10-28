# Mirravel 0.2.2 Beta — Mirror Glass

Mirravel now uses the selected **Mirror Glass** app icon and is available as a ready-to-extract **Mirravel.app** ZIP as well as a DMG.

## Downloads

- **Mirravel-0.2.2-Beta-App.zip** — extract and copy Mirravel.app to Applications.
- **Mirravel-0.2.2-Beta-Mac.dmg** — open and drag Mirravel.app to Applications.
- **Mirravel-0.2.2-Beta-Source.zip** — complete source code, artwork, guide and build scripts.
- **SHA256SUMS.txt** — package checksums.

The same signed app is supplied in the App ZIP and DMG. Its app icon includes standard and Retina sizes up to 1024 pixels. Finder, the Dock and the application bundle use the new icon.

## How it works

Open Mirravel.app to access the existing Terminal menu. Menu 1 reads diagnostics, menu 2 applies the experimental Mac-side patch after entering TEST and confirming the local administrator prompt, and menu 3 restores the tool's changes under the existing backup checks. The patch and backup logic are unchanged in this release.

On first launch, macOS may block this ad-hoc-signed, non-notarized beta. Go to **System Settings → Privacy & Security → Open Anyway**, confirm the prompt and reopen Mirravel. Terminal also needs **Full Disk Access** for the patch.

## Apple silicon and Intel

The app is universal: **arm64** and **x86_64** are verified in both download packages. Intel Macs require an **Apple T2 Security Chip**. Apple's iPhone Mirroring requirements also include **macOS 15 or later** and **iOS 18 or later**. A real Intel/T2 mirroring test has not been reported.

On 23 October 2026, PwnedG0blin confirmed a working iPhone Mirroring connection from within the EU using iOS 27.2 RC and macOS 27.2 RC with the corrected helper. This release packages that existing logic with the selected icon; it is not a new end-to-end hardware test. Long-term stability and other device combinations remain untested.

Free and open source under the MIT license. Developed by **PwnedG0blin**.

[Documentation](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/Mirravel) · [Upgrade compatibility](https://github.com/PwnedG0blin/PwnedG0blin/blob/master/projects/Mirravel/COMPATIBILITY.md)
