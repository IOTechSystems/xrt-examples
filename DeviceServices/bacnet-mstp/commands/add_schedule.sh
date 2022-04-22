#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"bacnet-mstp-sim-schedule1",
    "device":"bacnet-mstp-sim",
    "resource":["analog_input_0:present-value","analog_input_1:present-value"],
    "interval": 2000000
  }
}'
