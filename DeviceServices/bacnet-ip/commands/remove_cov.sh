#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/bacnet_ip -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "bacnet-ip-sim-cov1"
}'
