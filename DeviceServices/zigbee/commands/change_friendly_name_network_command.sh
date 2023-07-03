#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
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
