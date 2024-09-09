#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/s7 -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "values": {
    "IEC_COUNTER": {"PV": 3000, "CV": 300, "CU": True, "CD": False, "R": False, "LD": False, "QU": True, "QD": False}
  },
}'
