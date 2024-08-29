#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
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
