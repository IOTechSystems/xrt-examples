#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "zigbee_reporting_schedule"
}'
