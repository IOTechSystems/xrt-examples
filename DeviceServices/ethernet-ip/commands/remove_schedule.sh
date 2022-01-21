#!/bin/sh

mosquitto_pub -t xrt/schedule/ethernet_ip/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "ethernetip-sim-sched1"
}'
