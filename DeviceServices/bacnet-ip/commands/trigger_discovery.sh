#!/bin/sh

mosquitto_pub -t xrt/discovery/bacnet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger"
}'
