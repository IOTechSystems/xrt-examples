#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "LED_light_strip",
  "device_info":  {
    "profileName": "LED_strip_profile",
    "protocols":{
      "Zigbee":{
        "FriendlyName": "0x7cb03eaa00a9b799"
      }
    }
  }
}'
