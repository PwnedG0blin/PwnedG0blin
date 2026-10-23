# Mirravel 0.2.1 Beta

This update consistently uses **Mirravel** for the app, launcher, downloads, app identity, build workflow and current GitHub project pages.

## Changes

- App: **Mirravel.app**; source launcher: **Mirravel.command**.
- Downloads: **Mirravel-0.2.1-Beta-Mac.dmg** and **Mirravel-0.2.1-Beta-Source.zip**.
- Build workflow: **mirravel-beta.yml**.
- App name and bundle identifier now consistently use Mirravel.
- New installations save backups in `/private/var/db/mirravel`.
- Existing older backups are detected and reused, preserving restore and reapplication after macOS updates.
- If both backup directories exist, the tool stops before changing system data.
- Removed the old project directory from the current source tree; upgrade information is now in the Mirravel project.

## First launch on macOS

This beta is ad-hoc signed and not notarized. If macOS says **“Mirravel.app was blocked to protect your Mac”**:

1. Copy **Mirravel.app** to **Applications** and try opening it once.
2. Open **System Settings → Privacy & Security** and scroll to **Security**.
3. Click **Open Anyway** next to the Mirravel message and confirm the local prompt.
4. Open Mirravel again and choose **Open** if prompted.

Terminal also needs **Full Disk Access** to apply the experimental Mac patch. Start with menu **1 – Diagnose**. Use menu **2**, enter **TEST** and confirm the local administrator prompt to apply; menu **3** restores the tool's own changes.

## Compatibility and tests

The Mac-side eligibility patch is unchanged. On 23 October 2026, PwnedG0blin confirmed a working iPhone Mirroring connection from within the EU using iOS 27.2 RC and macOS 27.2 RC with the previously corrected helper. This naming update adds automated coverage for existing-backup compatibility; a new hardware test of this package has not been reported.

The release workflow checks shell syntax, isolated regression tests, the compiled AppleScript app, app identity, signatures, mounted DMG and source archive. Long-term connection stability and other device combinations remain outside that test scope.

Free and open source under the MIT license. Developed by **PwnedG0blin**.

[Download and source documentation](https://github.com/PwnedG0blin/PwnedG0blin/tree/master/projects/Mirravel) · [Upgrade compatibility](https://github.com/PwnedG0blin/PwnedG0blin/blob/master/projects/Mirravel/COMPATIBILITY.md)
