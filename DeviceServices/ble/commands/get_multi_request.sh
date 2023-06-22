#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ble -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
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
