#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "virtual-schedule1"
}'
