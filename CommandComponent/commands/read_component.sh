#!/bin/sh

mosquitto_pub -t xrt/command/request -m \
'{
  "client": "example",
  "request_id": "4321",
  "op": "component:read",
  "component": "2-logger",
  "type": "xrt.request:1.0"
}'
