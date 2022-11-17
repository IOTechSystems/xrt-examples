#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "LED_light_strip",
  "resource": [
      "brightness",
      "state",
      "color_temp"
  ]
}'
