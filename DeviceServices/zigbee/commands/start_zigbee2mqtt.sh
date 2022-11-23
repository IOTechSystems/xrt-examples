#!/bin/sh

TEMP=$(getopt -n "$0" -a -l "adapter:,network:,broker_address:" -- -- "$@")

[ $? -eq 0 ] || exit

eval set -- "$TEMP"

if [ $# -lt 6 ]
then
  echo "Incorrect arguments. Exiting..."
  exit
fi

while [ $# -gt 0 ]
do
  case "$1" in
    --adapter) adapter=$2; shift;;
    --network) dockernetwork=$2; shift;;
    --broker_address) mqttaddress=$2; shift;;
  esac
  shift;
done

if [ -z "$adapter" ] || [ -z "$dockernetwork" ] || [ -z "$mqttaddress" ]
then
  echo "Incorrect arguments. Exiting..."
  exit
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
  port: $adapter" > data/configuration.yaml
fi

docker run \
--name zigbee2mqtt \
--rm \
--network=$dockernetwork \
--device=$adapter \
-p 8080:8080 \
-v $(pwd)/data:/app/data \
-v /run/udev:/run/udev:ro \
-e TZ=Europe/London \
iotechsys/zigbee2mqtt:1.27.2
