#!/bin/sh

BLE_SIM=iotechsys/ble-sim:1.0.1.dev

docker pull $BLE_SIM
docker run --rm -d --name=ble-sim \
      -e RUN_BLUEZ=true \
      -e DEVICE_COUNT=1 \
      --privileged \
      -v /var/run/dbus/system_bus_socket/:/var/run/dbus/system_bus_socket/ \
      -v /etc/dbus-1/system.d/:/etc/dbus-1/system.d \
      --mount type=bind,source=/proc/1/ns/,target=/rootns \
      $BLE_SIM \
      --script /example-scripts/device-service-example.lua 
      