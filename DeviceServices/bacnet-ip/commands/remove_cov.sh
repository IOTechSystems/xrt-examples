#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client":"example",
  "request_id": 1051,
  "op": "schedule:delete",
  "schedule": "bacnet-ip-sim-cov1"
}'
