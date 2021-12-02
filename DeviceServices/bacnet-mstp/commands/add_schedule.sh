#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_mstp_device_service/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"bacnet-mstp-sim-schedule1",
    "device":"bacnet-mstp-sim",
    "resource":["analog_input_0:present-value","analog_input_1:present-value"],
    "interval": 2000000
  }
}'
