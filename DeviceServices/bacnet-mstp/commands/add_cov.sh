#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_mstp_device_service/request -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "schedule": {
    "name":"bacnet-mstp-sim-cov1",
    "device":"bacnet-mstp-sim",
    "resource":["analog_value_0:present-value","analog_value_1:present-value"],
    "interval": 100000,
    "options" : {
      "COV" : {
        "Confirmed": false,
        "Lifetime": 0
      }
    }
  }
}'
