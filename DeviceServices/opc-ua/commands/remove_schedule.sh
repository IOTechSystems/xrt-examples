#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "schedule1"
}'
