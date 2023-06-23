#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/zigbee -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "LED_light_strip",
  "resource": "state"
}'
