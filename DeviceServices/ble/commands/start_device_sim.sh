#!/bin/sh

BLE_SIM=${SPARKPLUG_GROUP}sys/ble-sim:1.0

docker pull $BLE_SIM
docker run --rm -d --name=ble-sim \
      -e RUN_BLUEZ=true \
      -e DEVICE_COUNT=1 \
      --privileged \
      -v /var/run/dbus/system_bus_socket/:/var/run/dbus/system_bus_socket/ \
      --mount type=bind,source=/proc/1/ns/,target=/rootns \
      -v /etc/dbus-1/system.d/:/etc/dbus-1/system.d/ \
      $BLE_SIM \
      --script /example-scripts/device-service-example.lua \
