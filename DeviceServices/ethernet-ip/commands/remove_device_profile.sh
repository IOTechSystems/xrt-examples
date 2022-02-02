#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profile": "ethernetip-sim-profile"
}'
