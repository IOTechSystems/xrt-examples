#!/bin/sh

BLE_SIM=iotechsys/ble-sim:1.0
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
HOST_STATE=/tmp/ble-sim-host-state

# Undo any host changes made so far, then exit
fail ()
{
  echo "Error: $1"
  $SCRIPT_DIR/stop_device_sim.sh
  exit 1
}

if docker ps -a --format "{{.Names}}" | grep -qx ble-sim; then
  echo "Error: the simulator is already running, stop it with stop_device_sim.sh first"
  exit 1
fi

# The simulator runs its own BlueZ and expects its virtual controllers to be hci0 and hci1,
# so the host bluetooth service and Bluetooth controllers are disabled while it runs.
# What is changed here is recorded in $HOST_STATE and restored by stop_device_sim.sh.
if systemctl is-active --quiet bluetooth 2>/dev/null; then
  echo "Stopping host bluetooth service"
  sudo systemctl mask --runtime bluetooth || fail "could not mask the bluetooth service"
  echo bluetooth >> $HOST_STATE
  sudo systemctl stop bluetooth || fail "could not stop the bluetooth service"
fi

# Release every controller by unbinding its device from its driver (btusb, hci_uart, btsdio, ...)
for hci in /sys/class/bluetooth/hci*; do
  name=${hci##*/}
  case $name in *:*|"hci*") continue ;; esac  # skip connection entries such as hci0:42
  if [ ! -e $hci/device/driver ]; then
    fail "$name is a virtual controller or has no driver to unbind"
  fi
  driver=$(readlink -f $hci/device/driver)
  device=$(basename $(readlink -f $hci/device))
  echo "Releasing $name ($(basename $driver) $device)"
  echo $device | sudo tee $driver/unbind > /dev/null || fail "could not release $name"
  echo "unbind $driver $device" >> $HOST_STATE
done
timeout 5 sh -c 'while ls /sys/class/bluetooth/ 2>/dev/null | grep -q "^hci[0-9]*$"; do sleep 0.2; done' ||
  fail "Bluetooth controllers are still present"

docker pull $BLE_SIM
docker run --rm -d --name=ble-sim \
      -e RUN_BLUEZ=true \
      -e DEVICE_COUNT=1 \
      --privileged \
      -v /var/run/dbus/system_bus_socket/:/var/run/dbus/system_bus_socket/ \
      --mount type=bind,source=/proc/1/ns/,target=/rootns \
      -v /etc/dbus-1/system.d/:/etc/dbus-1/system.d/ \
      -v $SCRIPT_DIR/ble-sim-main.conf:/etc/bluetooth/main.conf:ro \
      $BLE_SIM \
      --script /example-scripts/device-service-example.lua \
  || fail "could not start the simulator"
