#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "modbus-example-schedule1"
}'
