# Mirravel — iPhone Mirroring Diagnostics for Mac

**Free, open-source macOS helper for iPhone Mirroring diagnostics and experimental configuration. Version 0.1.1 Beta.**

Inspect local requirements, view Mac logs, and back up or restore settings changed by this tool. **Experimental beta; a successful mirroring connection is not guaranteed.** Previously called RegionPilot.

[Download beta](https://github.com/PwnedG0blin/PwnedG0blin/releases/tag/mirravel-v0.1.1-beta) · [Detailed German guide](README.md)

## What it does

- Read local eligibility and macOS version information without making changes.
- Optionally change three existing Mac-side eligibility values after explicit confirmation and a local administrator prompt.
- Save the original values and restore only its own changes under the documented validation rules.
- Open iPhone Mirroring, relevant privacy settings and local diagnostic logs.

Mirravel does not change the iPhone's location or its regional eligibility checks. A local answer value of 4 is not proof of a working connection. The documented hardware test showed timeouts; a reliable ongoing connection has not been established.

## Updates and data

The existing RegionPilot bundle ID and `/private/var/db/regionpilot` backup directory remain unchanged so previous backups can still be used. Restore before a macOS upgrade where possible; an old backup is not automatically applied to a different macOS build.

The app is ad-hoc signed, not Developer ID signed or notarized. Build and isolated regression tests do not replace hardware, Full Disk Access or end-to-end connection testing. Do not disable SIP or Gatekeeper globally.

## Build and support

On a Mac run `bash scripts/build-macos.sh`; the output is `dist/Mirravel-0.1.1-Beta-Mac.dmg`. Automated fixture tests: `python3 -m unittest discover -s tests -v`.

Developed by **PwnedG0blin**, [MIT license](LICENSE). [GitHub Sponsors](https://github.com/sponsors/PwnedG0blin) · [Patreon](https://www.patreon.com/cw/PwnedG0blinApp) · [X](https://x.com/PwnedG0blin)
