#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "LED_light_strip",
  "values": {
    "brightness": 254,
    "transition": 1,
    "state": true,
    "color_hs": {"hue": 100, "saturation": 100}
  }
}'
