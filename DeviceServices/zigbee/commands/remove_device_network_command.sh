#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "coordinator_device",
  "values": {
    "remove_device": "0x7cb03eaa00a9b799"
  }
}'
