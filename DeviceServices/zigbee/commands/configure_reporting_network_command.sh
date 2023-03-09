#!/bin/sh

mosquitto_pub -t xrt/devices/zigbee/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "coordinator_device",
  "values": {
    "configure_reporting": {"id": "0x000d6ffffe400162", "cluster": "msIlluminanceMeasurement", "attribute": "measuredValue", "minimum_report_interval":8,"maximum_report_interval":"8","reportable_change":1}
  }
}'
