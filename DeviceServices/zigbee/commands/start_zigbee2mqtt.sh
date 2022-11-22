#!/bin/sh

read -p "Input Zigbee adapter location:" adapterlocation
read -p "MQTT broker on host network? (y/n)" mqttnetworkyn
read -p "Input MQTT server address:" mqttaddress

if [ "$mqttnetworkyn" = "y" ] || [ "$mqttnetworkyn" = "Y" ]; then
  mqttnetwork="host"
else
  mqttnetwork="bridge"
fi

if [ ! -d "data" ]; then
  mkdir data
fi

if [ ! -f "data/configuration.yaml" ]; then
  touch data/configuration.yaml
  echo "homeassistant: false
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
  # Location of Zigbee adapter
  port: $adapterlocation" > data/configuration.yaml
fi

docker run \
--name zigbee2mqtt \
--restart=unless-stopped \
--network=$mqttnetwork \
--device=$adapterlocation \
-p 8080:8080 \
-v $(pwd)/data:/app/data \
-v /run/udev:/run/udev:ro \
-e TZ=Europe/London \
iotechsys/zigbee2mqtt:1.27.2
