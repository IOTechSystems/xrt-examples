#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "modbus-sim",
  "resource": [
      "Current",
      "Power"
      "Voltage"
    ]
}'
