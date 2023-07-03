#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim",
  "resource": [
      "analog_input_0:present-value",
      "analog_input_1:present-value",
      "analog_value_0:present-value",
      "analog_value_1:present-value"
    ]
}'
