#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
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
