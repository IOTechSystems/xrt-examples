#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client": "xrt bacnet-mstp example",
  "request_id": "1021",
  "op": "device:delete_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "bacnet-mstp-sim-01",
    "bacnet-mstp-sim-02",
    "bacnet-mstp-sim-03"
  ]
}'
