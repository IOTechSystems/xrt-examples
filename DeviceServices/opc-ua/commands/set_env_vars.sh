#!/bin/sh

export OPCUA_SIM_ADDRESS=localhost:49947
export OPCUA_LDS_ADDRESS=localhost:4840

export XRT_PROFILE_DIR=$PWD/profiles/
export XRT_STATE_DIR=$PWD/state/

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
