#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "bacnet-sim",
  "profile": "bacnet-sim-profile",
  "device_info":{
    "protocols":{
      "BACnet-IP":{
        "DeviceInstance": "1234"
      }
    }
  }
}'
