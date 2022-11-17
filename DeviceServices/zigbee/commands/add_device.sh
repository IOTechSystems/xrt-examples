#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "multi_sensor",
  "device_info":  {
    "profileName": "multi_sensor_profile",
    "protocols":{
      "Zigbee":{
        "FriendlyName": "0x000d6ffffe400162"
      }
    }
  }
}'
