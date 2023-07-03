#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client": "example",
  "request_id": "1050",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"bacnet-ip-sim-cov1",
    "device":"bacnet-ip-sim",
    "resource":["analog_value_0:present-value","analog_value_1:present-value"],
    "options" : {
      "COV" : {
        "Confirmed": false,
        "Lifetime": 0
      }
    }
  }
}'
