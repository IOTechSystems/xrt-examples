#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim",
  "device_info":  {
    "profileName": "bacnet-mstp-sim-profile",
    "protocols":{
      "BACnet-MSTP":{
        "DeviceInstance": 1234
      }
    }
  }
}'
