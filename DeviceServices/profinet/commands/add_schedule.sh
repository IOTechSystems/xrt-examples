#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/profinet -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"profinet-schedule1",
    "device":"netHAT",
    "resource":["InputUint32","InputUint16-offset-5"],
    "interval": 1000000
  }
}'
