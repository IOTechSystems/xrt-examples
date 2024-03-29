#!/bin/sh

export GPS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gps-sim)

export XRT_PROFILE_DIR=$PWD/deployment/profiles/
export XRT_STATE_DIR=$PWD/deployment/state/

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
