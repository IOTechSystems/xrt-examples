#!/bin/sh

mosquitto_pub -t xrt/command/request -m \
'{
  "client": "example",
  "request_id": "1234",
  "op": "component:list",
  "type": "xrt.request:1.0"
}'
