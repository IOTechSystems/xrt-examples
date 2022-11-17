#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
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
    "color_hs": {"hue": 100, "saturation": 200}
  }
}'
