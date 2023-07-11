#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/profinet -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "resource": ["InputUint32", "InputUint16-offset-5"]
}'
