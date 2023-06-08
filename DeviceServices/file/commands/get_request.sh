#!/bin/sh

mosquitto_pub -t xrt/devices/file/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "file-example",
  "resource": "file_string"
}'
