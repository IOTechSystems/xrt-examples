#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ble -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "ble-sim",
  "device_info":  {
    "profileName": "ble-sim-profile",
    "protocols": {
      "BLE": {
        "MAC": "00:AA:01:01:00:24"
      }
    }
  }
}'
