#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "opc-ua-sim",
  "resource": [
      "Counter",
      "Random",
      "Sawtooth",
      "Sinusoid",
      "Square",
      "Triangle",
      "Static",
      "Static2"
    ]
}'
