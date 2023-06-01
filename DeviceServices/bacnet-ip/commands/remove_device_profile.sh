#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/node0/bacnet_ip -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "bacnet-ip-sim-profile"
}'
