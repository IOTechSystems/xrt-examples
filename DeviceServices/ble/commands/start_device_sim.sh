#!/bin/sh

BLE_SIM=iotechsys/ble-sim:1.0.1.dev

sudo rm -rf /var/lib/bluetooth/*; sudo mkdir -p /var/lib/bluetooth/00:AA:01:00:00:23/00:AA:01:01:00:24/ && \
printf "[General]\nName=test\nAddressType=public\nSupportedTechnologies=LE;\nTrusted=false\nBlocked=false" | \
sudo tee /var/lib/bluetooth/00:AA:01:00:00:23/00:AA:01:01:00:24/info

docker pull $BLE_SIM
docker run --rm -d --name=ble-sim \
      --privileged \
      -v /var/run/dbus/system_bus_socket/:/var/run/dbus/system_bus_socket/ \
      $BLE_SIM \
      --script /example-scripts/device-service-example.lua 
