#!/bin/sh

mosquitto_pub -t xrt/profile/bacnet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profile": "bacnet-ip-sim-profile"
}'
