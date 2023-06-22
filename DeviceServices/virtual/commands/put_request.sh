#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/virtual -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device",
  "values": {
    "StoreInt32Value": 25
  }
}'
