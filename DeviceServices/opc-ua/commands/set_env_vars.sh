#!/bin/sh

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

export OPCUA_SIM_ADDRESS=localhost:49947
export OPCUA_LDS_ADDRESS=localhost:4840

export XRT_PROFILE_DIR=$SCRIPT_DIR/../profiles/
export XRT_STATE_DIR=$SCRIPT_DIR/../state/

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
