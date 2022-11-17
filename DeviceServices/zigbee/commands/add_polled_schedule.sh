#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"zigbee_polled_schedule",
    "device":"LED_light_strip",
    "resource":["brightness"],
    "interval": 5000000
  }
}'
