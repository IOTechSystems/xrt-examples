#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_mstp_device_service/request -m \
'{
  "client":"example",
  "request_id": "1051",
  "op": "schedule:delete",
  "schedule": "bacnet-mstp-sim-cov1"
}'