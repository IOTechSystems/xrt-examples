#!/bin/sh

mosquitto_pub -t xrt/command/request -m \
'{
  "client": "example",
  "request_id": "1357",
  "op": "component:update",
  "component": "2-logger",
  "config": { "Level": "Debug" },
  "type": "xrt.request:1.0"
}'
