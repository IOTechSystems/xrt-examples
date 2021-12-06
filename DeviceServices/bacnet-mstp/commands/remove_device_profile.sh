#!/bin/sh

mosquitto_pub -t xrt/profile/bacnet_mstp_device_service/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profile": "bacnet-mstp-sim-profile"
}'
