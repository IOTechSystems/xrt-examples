#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client":"xrt bacnet-mstp example",
  "request_id": "1035",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim"
}'
