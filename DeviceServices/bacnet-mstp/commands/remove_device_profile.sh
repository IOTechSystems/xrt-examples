#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client": "example",
  "request_id": 1012,
  "op": "profile:delete",
  "profile": "bacnet-mstp-sim-profile"
}'
