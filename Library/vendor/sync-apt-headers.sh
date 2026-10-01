#!/usr/bin/env bash
# Regenerates vendor/iot/include from the IOTech apt package installed on
# this host. Requires the iotech debian-dev apt repo
# configured (see /etc/apt/sources.list.d/iotech.list) and:
#   apt-get install iotech-iot-1.6-dev
#
# It's available on the public debian-release repo too, but not yet for the
# version used by XRT 3.4.
#
# Does NOT touch vendor/xrt - no confirmed iotech-xrt-dev apt/apk package
# yet, see README.md.
set -euo pipefail

VENDOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for pkg in iotech-iot-1.6-dev; do
  dpkg -s "$pkg" >/dev/null 2>&1 || {
    echo "error: $pkg is not installed (apt-get install $pkg)" >&2
    exit 1
  }
done

mkdir -p "${VENDOR_DIR}/iot/include"

rsync -a --delete /opt/iotech/iot/1.6/include/ "${VENDOR_DIR}/iot/include/"

echo "vendor/iot/include synced from the installed apt package."
