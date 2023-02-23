#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "ethernetip-sim",
  "resource": [
      "DO1",
      "DO2",
      "DO3",
      "DO4", 
      "VendorID",
      "DeviceType" 
    ]
}'
