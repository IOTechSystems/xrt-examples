#!/bin/sh

mosquitto_pub -t xrt/devices/profinet/request -m \
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
