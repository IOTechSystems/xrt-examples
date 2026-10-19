#!/bin/sh

BLE_SIM=iotechsys/ble-sim:1.0
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
HELPER=$SCRIPT_DIR/helper

# Undo any host changes made so far, then exit
fail ()
{
  trap '' INT TERM HUP  # do not let a second signal interrupt the restore
  $HELPER/restore_host.sh
  exit 1
}

$HELPER/check_host.sh $BLE_SIM || exit 1

trap fail INT TERM HUP
$HELPER/release_host.sh || fail

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
  || fail

$HELPER/wait_for_sim.sh || fail
trap - INT TERM HUP
