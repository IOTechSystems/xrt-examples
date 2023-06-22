#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/bacnet_mstp -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "bacnet-mstp-sim-cov1"
}'
