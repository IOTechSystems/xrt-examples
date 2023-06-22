#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/bacnet_ip -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "bacnet-ip-sim",
  "device_info":  {
    "profileName": "bacnet-ip-sim-profile",
    "protocols":{
      "BACnet-IP":{
        "DeviceInstance": 1234
      }
    }
  }
}'
