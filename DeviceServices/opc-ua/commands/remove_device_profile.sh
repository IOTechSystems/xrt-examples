#!/bin/sh

mosquitto_pub -t xrt/profile/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profile": "opc-ua-sim-profile"
}'
