#!/bin/sh

mosquitto_pub -t xrt/schedule/ethernet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "ethernetip-sim-sched1"
}'
