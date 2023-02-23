#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "ethernetip-sim-sched1"
}'
