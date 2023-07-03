#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "LED_light_strip",
  "values": {
    "brightness": 150
  }
}'
