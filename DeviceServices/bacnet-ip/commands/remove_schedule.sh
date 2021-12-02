#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "bacnet-ip-sim-schedule1"
}'
