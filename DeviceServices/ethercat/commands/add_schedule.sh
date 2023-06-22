#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ethercat -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"ethercat-schedule1",
    "device":"XMC4800",
    "resource":["IN_GET_BIT1","IN_GEN_BIT2"],
    "interval": 1000000
  }
}'
