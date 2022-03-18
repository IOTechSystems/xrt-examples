#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "profileName": "bacnet-ip-sim-profile"
}'
