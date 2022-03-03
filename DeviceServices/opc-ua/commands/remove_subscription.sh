#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "opc-ua-sim-subscription1"
}'
