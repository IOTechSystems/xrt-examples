#!/bin/sh
# The simulator runs its own BlueZ and expects its virtual controllers to be hci0 and hci1,
# so the host bluetooth service and Bluetooth controllers are disabled while it runs.
# What is changed here is recorded in $HOST_STATE and restored by restore_host.sh.
# Each change is recorded before it is made, restore_host.sh tolerates entries that were never applied.

. "$(dirname "$0")/common.sh"

# The service is masked even when it is not running, as D-Bus activation could start it during the simulation.
# A service that is not installed or is already masked is left alone.
if [ "$(systemctl show -p LoadState --value bluetooth 2>/dev/null)" = loaded ]; then
  was_active=false
  systemctl is-active --quiet bluetooth && was_active=true
  echo "Masking host bluetooth service"
  echo bluetooth-mask >> $HOST_STATE
  $was_active && echo bluetooth-start >> $HOST_STATE
  sudo systemctl mask --runtime bluetooth || { echo "Error: could not mask the bluetooth service"; exit 1; }
  if $was_active; then
    echo "Stopping host bluetooth service"
    sudo systemctl stop bluetooth || { echo "Error: could not stop the bluetooth service"; exit 1; }
  fi
fi

# Release every controller by unbinding its device from its driver (btusb, hci_uart, btsdio, ...)
for hci in /sys/class/bluetooth/hci*; do
  name=${hci##*/}
  case $name in *:*) continue ;; hci[0-9]*) ;; *) continue ;; esac  # skip connection entries such as hci0:42
  if [ ! -e $hci/device/driver ]; then  # checked by check_host.sh, this covers a controller that appeared since
    echo "Error: $name is a virtual controller or has no driver to unbind"
    exit 1
  fi
  driver=$(readlink -f $hci/device/driver)
  device=$(basename $(readlink -f $hci/device))
  echo "Releasing $name ($(basename $driver) $device)"
  echo "unbind $driver $device" >> $HOST_STATE
  echo $device | sudo tee $driver/unbind > /dev/null || { echo "Error: could not release $name"; exit 1; }
done
timeout 5 sh -c 'while ls /sys/class/bluetooth/ 2>/dev/null | grep -q "^hci[0-9]*$"; do sleep 0.2; done' ||
  { echo "Error: Bluetooth controllers are still present"; exit 1; }
