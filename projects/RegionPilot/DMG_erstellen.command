#!/bin/bash
# Copyright (c) 2026 PwnedG0blin · Developed by PwnedG0blin · SPDX-License-Identifier: MIT
set -euo pipefail
here="$(cd -- "$(dirname -- "$0")" && pwd -P)"
/bin/bash "$here/scripts/build-macos.sh"
/usr/bin/open "$here/dist"
