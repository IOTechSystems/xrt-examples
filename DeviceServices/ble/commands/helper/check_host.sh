#!/bin/sh
# Checks everything that can reasonably fail before the host is changed, so that a failure leaves nothing to restore.
# Usage: check_host.sh <simulator image>

BLE_SIM=$1
HELPER_DIR=$(cd "$(dirname "$0")" && pwd)
. "$HELPER_DIR/common.sh"

mkdir -p -m 700 "$STATE_DIR" 2>/dev/null
if [ -L "$STATE_DIR" ] || [ ! -d "$STATE_DIR" ] || [ ! -O "$STATE_DIR" ]; then
  echo "Error: $STATE_DIR must be a directory owned by the current user"
  exit 1
fi
if [ -L "$HOST_STATE" ] || { [ -e "$HOST_STATE" ] && [ ! -O "$HOST_STATE" ]; }; then
  echo "Error: $HOST_STATE must be a regular file owned by the current user"
  exit 1
fi

if sim_exists; then
  echo "Error: the simulator is already running, stop it with stop_device_sim.sh first"
  exit 1
fi

# An earlier run that was killed or only partly restored leaves its record behind.
# Restore that first so the new run starts from the host's original state.
if [ -s "$HOST_STATE" ]; then
  echo "Restoring the host from an earlier run"
  "$HELPER_DIR/restore_host.sh" || { echo "Error: could not restore the host, fix this and try again"; exit 1; }
fi

if ! docker pull "$BLE_SIM"; then
  docker image inspect "$BLE_SIM" > /dev/null 2>&1 || { echo "Error: could not pull $BLE_SIM"; exit 1; }
  echo "Warning: could not pull $BLE_SIM, using the local copy"
fi

# Ask for the sudo password now rather than part way through the changes
sudo -v || { echo "Error: sudo is required to release the Bluetooth controllers"; exit 1; }

for hci in /sys/class/bluetooth/hci*; do
  name=${hci##*/}
  case $name in *:*) continue ;; hci[0-9]*) ;; *) continue ;; esac  # skip connection entries such as hci0:42
  if [ ! -e $hci/device/driver ]; then
    echo "Error: $name is a virtual controller or has no driver to unbind"
    exit 1
  fi
done
