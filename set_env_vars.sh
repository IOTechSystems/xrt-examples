#!/bin/sh

export XRT_PROFILE_DIR=$PWD/deployment/state/profiles
export XRT_STATE_DIR=$PWD/deployment/state
export XRT_LUA_FILE=$PWD/deployment/config/example.lua

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""

# Just used for ApplicationComponent Example
export IOT_DIR=/opt/iotech/iot/1.5
export XRT_DIR=/opt/iotech/xrt/3.0

# OPC-UA Server Basic Profile and State directories
export XRT_VIRTUAL_PROFILE_DIR=../../../DeviceServices/virtual/deployment/state/profiles
export XRT_VIRTUAL_STATE_DIR=../../../DeviceServices/virtual/deployment/state

export XRT_BACNET_IP_PROFILE_DIR=../../../DeviceServices/bacnet-ip/deployment/state/profiles
export XRT_BACNET_IP_STATE_DIR=../../../DeviceServices/bacnet-ip/deployment/state

export XRT_FILE_STATE_DIR=../../../DeviceServices/file/deployment/state

export XRT_MODBUS_TCP_PROFILE_DIR=../../../DeviceServices/modbus-tcp/deployment/state/profiles
export XRT_MODBUS_TCP_STATE_DIR=../../../DeviceServices/modbus-tcp/deployment/state

# OPC-UA server node modelling example 
export XRT_MODELS_DIR=$PWD/deployment/models
export XRT_NODESET_DIR=$PWD/deployment/nodesets

# Sparkplug Vars
export SPARKPLUG_NODE=xrt
export SPARKPLUG_NODE2=xrt2
export SPARKPLUG_GROUP=iotech
export SPARKPLUG_PROTO=spb

# Service Names
export FILE_SERVICE=file
export CANBUS_SERVICE=canbus

#NEW CHANGES 
#export XRT_MQTT_BROKER=tcp://localhost:1883-->1
export XRT_MQTT_USERNAME=test
export XRT_MQTT_PASSWORD=test
export SPARKPLUG_NODE1=device1
export AZURE_EXPORTER_HOSTNAME=IOTechHub.azure-devices.net
export AZURE_EXPORTER_DEVICE_ID=device-42
export AZURE_EXPORTER_SCOPE_ID=0ne0017479D
export AZURE_EXPORTER_CERTIFICATE=/path/to/device-42.cert.pem
export AZURE_EXPORTER_KEY=/path/to/device-42.key.pem
export XRT_LICENSE_FILE=/home/snehal/Documents/gitdir2/xrt-examples/DeviceServices/virtual/deployment/config #instead of this add license fie in the folder --->2
export XRT_MQTT_BROKER=mqtt://127.0.0.1:1883 #--->1



