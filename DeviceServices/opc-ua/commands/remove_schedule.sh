#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "opc-ua-sim-schedule1"
}'
