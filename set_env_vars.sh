#!/bin/sh

export XRT_PROFILE_DIR=$PWD/deployment/profiles
export XRT_STATE_DIR=$PWD/deployment/state

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""

# Just used for ApplicationComponent Example
export IOT_DIR=/opt/iotech/iot/1.4
export XRT_DIR=/opt/iotech/xrt/2.1

# OPC-UA server node modelling example 
export XRT_MODELS_DIR=$PWD/deployment/models
export XRT_NODESET_DIR=$PWD/deployment/nodesets
