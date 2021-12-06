#!/bin/sh

export ETHERNETIP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ethernetip-sim)

export XRT_PROFILE_DIR=$PWD/profiles/
export XRT_STATE_DIR=$PWD/state/

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
