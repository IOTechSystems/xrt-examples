#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"bacnet-ip-sim-schedule1",
    "device":"bacnet-ip-sim",
    "resource":["analog_input_0:present-value","analog_input_1:present-value"],
    "interval": 2000000
  }
}'
