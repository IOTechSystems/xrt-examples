#!/bin/sh

mosquitto_pub -t xrt/command/discovery -m \
'{
  "client": "example",
  "op": "discovery:discover",
  "type": "xrt.request:1.0"
}'
