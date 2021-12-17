#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client": "example",
  "request_id": 1060,
  "op": "device:add",
  "device": "bacnet-ip-sim",
  "device_info":  {
    "protocols":{
      "BACnet-IP":{
        "DeviceInstance": "1234"
      }
    }
  }
}'
