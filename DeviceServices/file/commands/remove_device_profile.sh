#!/bin/sh

mosquitto_pub -t xrt/devices/file/request -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "file-example"
}'
