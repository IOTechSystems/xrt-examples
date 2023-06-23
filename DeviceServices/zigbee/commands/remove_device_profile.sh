#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/zigbee -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "LED_strip_profile"
}'
