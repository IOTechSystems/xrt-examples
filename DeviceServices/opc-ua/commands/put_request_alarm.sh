#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "alarm test",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "test_alarm",
  "values": {
    "set_alarm_severity": 5,
  },
}'
