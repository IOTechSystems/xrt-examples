#!/bin/sh

export MODBUS_DEVICE_ADDRESS=localhost
export MODBUS_DEVICE_PORT=1502

export XRT_PROFILE_DIR=$PWD/deployment/profiles/
export XRT_STATE_DIR=$PWD/deployment/state/

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
