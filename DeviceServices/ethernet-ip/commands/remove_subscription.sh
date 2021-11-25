#!/bin/sh

mosquitto_pub -t xrt/schedule/ethernet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "ethernetip-sim-sub1"
}'
