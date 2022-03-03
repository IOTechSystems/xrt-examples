#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "bacnet-mstp-sim-cov1"
}'
