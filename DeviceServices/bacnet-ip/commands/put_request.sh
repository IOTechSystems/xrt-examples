#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "bacnet-sim",
  "values": {
    "ns=2;s=WritableInt64": 42,   // TODO
  }
}'
