#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"zigbee_reporting_schedule",
    "device":"multi_sensor",
    "resource":["illuminance", "illuminance_lux"],
    "options": {"isReporting": true}
  }
}'
