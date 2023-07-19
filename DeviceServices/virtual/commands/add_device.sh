#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device",
  "device_info":  {
    "profileName": "device-virtual",
    "protocols":{
      "Other":{
        "Address": "device-virtual-01"
      }
    }
  }
}'
