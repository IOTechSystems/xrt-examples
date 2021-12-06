#!/bin/sh

mosquitto_pub -t xrt/schedule/opc_ua_device_service/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "opc-ua-sim-subscription1"
}'
