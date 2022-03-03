#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "ble-sim-schedule1"
}'
