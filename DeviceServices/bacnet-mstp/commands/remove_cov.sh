#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "bacnet-mstp-sim-cov1"
}'
