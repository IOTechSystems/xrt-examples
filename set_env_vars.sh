#!/bin/sh

export XRT_PROFILE_DIR=$PWD/deployment/profiles
export XRT_STATE_DIR=$PWD/deployment/state
export XRT_LUA_FILE=$PWD/deployment/config/example.lua

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""

# Just used for ApplicationComponent Example
export IOT_DIR=/opt/iotech/iot/1.5
export XRT_DIR=/opt/iotech/xrt/3.0

# OPC-UA Server Basic Profile and State directories
export XRT_VIRTUAL_PROFILE_DIR=../../../DeviceServices/virtual/deployment/profiles
export XRT_VIRTUAL_STATE_DIR=../../../DeviceServices/virtual/deployment/state

export XRT_BACNET_IP_PROFILE_DIR=../../../DeviceServices/bacnet-ip/deployment/profiles
export XRT_BACNET_IP_STATE_DIR=../../../DeviceServices/bacnet-ip/deployment/state

export XRT_FILE_STATE_DIR=../../../DeviceServices/file/deployment/state

export XRT_MODBUS_TCP_PROFILE_DIR=../../../DeviceServices/modbus-tcp/deployment/profiles
export XRT_MODBUS_TCP_STATE_DIR=../../../DeviceServices/modbus-tcp/deployment/state

# OPC-UA server node modelling example 
export XRT_MODELS_DIR=$PWD/deployment/models
export XRT_NODESET_DIR=$PWD/deployment/nodesets

# Sparkplug Vars
export SPARKPLUG_NODE=xrt
export SPARKPLUG_GROUP=iotech
export SPARKPLUG_PROTO=spb

# Service Names
export FILE_SERVICE=file
export CANBUS_SERVICE=canbus
