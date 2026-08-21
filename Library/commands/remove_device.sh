#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1011",
  "op": "device:delete",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device"
}'
