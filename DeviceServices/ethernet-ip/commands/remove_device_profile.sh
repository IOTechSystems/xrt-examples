#!/bin/sh

mosquitto_pub -t xrt/profile/ethernet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profile": "ethernetip-sim-profile"
}'
