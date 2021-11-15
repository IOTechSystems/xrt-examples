#!/bin/sh

mosquitto_pub -t xrt/discovery/opc_ua_device_service/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger"
}'
