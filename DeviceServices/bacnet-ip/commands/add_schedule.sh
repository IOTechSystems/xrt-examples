#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"bacnet-sim-schedule1",
    "device":"bacnet-sim",
    "resource":["ns=3;s=Random"],    // TODO
    "interval": 1000000
  }
}'
