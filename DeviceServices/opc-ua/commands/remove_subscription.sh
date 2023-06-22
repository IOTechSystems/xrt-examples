#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/opc_ua -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "opc-ua-sim-subscription1"
}'
