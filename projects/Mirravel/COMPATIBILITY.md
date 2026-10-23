# Mirravel upgrade compatibility

## Existing backups

New installations use `/private/var/db/mirravel`. Existing installations may still have their backup under `/private/var/db/regionpilot`; this legacy path is retained only so an earlier backup can still be found and restored.

Mirravel reuses that existing directory without moving it, changing its permissions, or copying an old system database over the current one. The original owner, permission, symlink, lock, build and key checks still apply. If both directories exist, it stops before making changes so the correct backup can be checked. Do not delete either directory just to bypass that check.

Menu 3 restores only the three saved eligibility values for the matching macOS build. After a build change, menu 2 can archive the previous baseline and save the current build before reapplying the patch.

## App identity and first launch

The app identifier is now `io.github.pwnedg0blin.Mirravel`. Replace the older app with `Mirravel.app` from the new DMG. macOS may request a new first-launch approval under **System Settings → Privacy & Security → Open Anyway**. The patch still runs in Terminal, which needs its own **Full Disk Access** permission.

## Current downloads

Use the current **Mirravel** release and the files named `Mirravel-…-Mac.dmg` or `Mirravel-…-Source.zip`. The launcher is `Mirravel.command`. Historical releases remain available with their original tags and filenames.
