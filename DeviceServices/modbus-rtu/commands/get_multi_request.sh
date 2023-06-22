#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus-rtu -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "modbus-sim",
  "resource": [
      "Current",
      "Power"
      "Voltage"
    ]
}'
