#!/bin/sh
mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "opc-ua-simulator",
  "resource": [
      "ns=3;s=Counter",
      "ns=3;s=Random",
      "ns=3;s=Sawtooth",
      "ns=3;s=Triangle", 
      "ns=3;s=Sinusoid" 
    ]
}'