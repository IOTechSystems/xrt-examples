#!/bin/sh

read -p "Input Zigbee adapter location:" adapterlocation
read -p "Input MQTT server address:" mqttaddress

if [ ! -d "data" ]; then
  mkdir data
fi

if [ ! -f "data/configuration.yaml" ]; then
  touch data/configuration.yaml
  echo " # Home Assistant integration (MQTT discovery)
homeassistant: false
# allow new devices to join
permit_join: true
# MQTT settings
mqtt:
  # MQTT base topic for zigbee2mqtt MQTT messages
  base_topic: zigbee2mqtt
  # MQTT server URL
  server: '$mqttaddress'
  # MQTT server authentication, uncomment if required:
  # user: my_user
  # password: my_password
# Serial settings
serial:
  # Location of CC2531 USB sniffer
  port: $adapterlocation
frontend: true" > data/configuration.yaml
fi

docker run \
--name zigbee2mqtt \
--restart=unless-stopped \
--network=host \
--device=$adapterlocation \
-p 8080:8080 \
-v $(pwd)/data:/app/data \
-v /run/udev:/run/udev:ro \
-e TZ=Europe/London \
iotechsys/zigbee2mqtt:1.27.2
