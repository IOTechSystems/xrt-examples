#!/usr/bin/env bash
# Regenerates vendor/{iot,paho,sparkplug-b}/include from the IOTech apt
# packages installed on this host. Requires the iotech debian-dev apt repo
# configured (see /etc/apt/sources.list.d/iotech.list) and:
#   apt-get install iotech-iot-1.6-dev iotech-libpaho-mqtt-1.3 libsparkplug-b-1.0
# 
# All are available on public debian-release repo too, but not for all current
# versions used by XRT 3.4 yet.
#
# Does NOT touch vendor/xrt - no confirmed iotech-xrt-dev apt/apk package
# yet, see README.md.
set -euo pipefail

VENDOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for pkg in iotech-iot-1.6-dev iotech-libpaho-mqtt-1.3 libsparkplug-b-1.0; do
  dpkg -s "$pkg" >/dev/null 2>&1 || {
    echo "error: $pkg is not installed (apt-get install $pkg)" >&2
    exit 1
  }
done

mkdir -p "${VENDOR_DIR}/iot/include" "${VENDOR_DIR}/paho/include" "${VENDOR_DIR}/sparkplug-b/include"

rsync -a --delete /opt/iotech/iot/1.6/include/ "${VENDOR_DIR}/iot/include/"
rsync -a --delete --include='MQTT*.h' --exclude='*' /usr/include/ "${VENDOR_DIR}/paho/include/"
rsync -a --delete /usr/include/sparkplug-b/ "${VENDOR_DIR}/sparkplug-b/include/sparkplug-b/"

echo "vendor/{iot,paho,sparkplug-b}/include synced from installed apt packages."
