#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/zigbee -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "coordinator_device",
  "resource": "health_check"
}'
