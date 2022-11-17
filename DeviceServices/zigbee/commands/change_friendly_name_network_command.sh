#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "coordinator_device",
  "values": {
    "change_friendly_name": {"from": "0x7cb03eaa00a9b799", "to": "LED_new_friendly_name"}
  }
}'
