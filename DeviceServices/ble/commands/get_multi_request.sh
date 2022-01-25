#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "ble-sim",
  "resource": [
      "Counter",
      "Random",
      "Sawtooth",
      "Sinusoid",
      "Square",
      "Triangle",
      "Static"
    ]
}'
