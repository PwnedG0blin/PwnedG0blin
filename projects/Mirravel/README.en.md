# Mirravel — iPhone Mirroring Diagnostics for Mac

**Free, open-source macOS helper for iPhone Mirroring diagnostics and experimental configuration. Version 0.2.0 Beta.**

Inspect local requirements, view Mac logs, and back up or restore settings changed by this tool. **Experimental beta; a successful mirroring connection is not guaranteed.** Previously called RegionPilot.

[Download beta](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/mirravel-v0.2.0-beta) · [Detailed German guide](README.md)

## EU purpose and experimental bypass

Mirravel is intended for users in the European Union and aims to experimentally bypass Apple’s regional restriction on iPhone Mirroring. It provides diagnostics and Mac-side configuration changes with backup and restore of its own changes. On 23 October 2026, PwnedG0blin confirmed a working iPhone Mirroring connection from within the EU with iOS 27.2 RC and macOS 27.2 RC. iPhone-side eligibility checks and future system updates may still affect connectivity.

Apple lists iPhone Mirroring as unavailable in the EU: [Apple Support](https://support.apple.com/en-euro/120421).

## What it does

- Read local eligibility and macOS version information without making changes.
- Optionally change three existing Mac-side eligibility values after explicit confirmation and a local administrator prompt.
- Save the original values and restore only its own changes under the documented validation rules.
- Open iPhone Mirroring, relevant privacy settings and local diagnostic logs.

Mirravel does not change the iPhone's location or its regional eligibility checks. A local answer value of 4 is not proof of a working connection. The latest device test on 23 October 2026 confirmed a working connection from within the EU with iOS 27.2 RC and macOS 27.2 RC after reapplying the Mac patch. Exact RC build numbers were not supplied. Earlier beta tests had shown timeouts; long-term stability and other device combinations remain untested.

## Updates and data

The existing RegionPilot bundle ID and `/private/var/db/regionpilot` backup directory remain unchanged so previous backups can still be used. If an update resets Mac eligibility to answer 2, menu 2 can reapply the patch. On a build change, the previous backup is copied to a private `previous-build.XXXXXX` directory and verified byte for byte before the current macOS state is saved as the new baseline. Old system values are never restored over a new build. The same-build safeguard remains in place.

The app is ad-hoc signed, not Developer ID signed or notarized. Build and isolated regression tests do not replace hardware, Full Disk Access or end-to-end connection testing. Do not disable SIP or Gatekeeper globally.

## First launch: allow Mirravel in macOS

This beta is ad-hoc signed and not notarized, so macOS may show **“Mirravel.app was blocked to protect your Mac.”**

1. After copying the app to **Applications**, try opening **Mirravel.app** once.
2. Open **System Settings → Privacy & Security** and scroll to **Security**.
3. Click **Open Anyway** next to the message about **Mirravel.app**.
4. Confirm the local macOS prompt, then open Mirravel again and choose **Open** if prompted.

Allowing the app to open is separate from granting **Terminal → Full Disk Access**, which is also required to apply the experimental patch.

## Build and support

On a Mac run `bash scripts/build-macos.sh`; the output is `dist/Mirravel-0.2.0-Beta-Mac.dmg`. Automated fixture tests: `python3 -m unittest discover -s tests -v`.

Developed by **PwnedG0blin**, [MIT license](LICENSE). [GitHub Sponsors](https://github.com/sponsors/PwnedG0blin) · [Patreon](https://www.patreon.com/cw/PwnedG0blinApp) · [X](https://x.com/PwnedG0blin)

