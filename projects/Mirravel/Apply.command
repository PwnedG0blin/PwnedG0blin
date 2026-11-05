#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · SPDX-License-Identifier: MIT
set -uo pipefail
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
here="$(cd -- "$(dirname -- "$0")" && pwd -P)"
printf '\nMirravel: apply\nTerminal benötigt Full Disk Access.\n\n'
/usr/bin/sudo /bin/bash "$here/core.sh" apply
result=$?
if [ "$result" -ne 0 ]; then
  printf '\nVorgang abgebrochen oder fehlgeschlagen (Status %s).\n' "$result"
fi
printf '\nZur App zurückkehren und Diagnose wählen. Enter schließt dieses Skript.\n'
read -r _
exit "$result"
