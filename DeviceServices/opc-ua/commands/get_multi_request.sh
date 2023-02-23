#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "resource": [
      "ns=3;s=Counter:value",
      "ns=3;s=Random:value",
      "ns=3;s=Sawtooth:value",
      "ns=3;s=Triangle:value", 
      "ns=3;s=Sinusoid:value" 
    ]
}'
