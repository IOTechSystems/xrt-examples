#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "ethernetip-sim",
  "resource": [
      "DI1",
      "DI2",
      "DO1",
      "DO2", 
      "VendorID",
      "DeviceType" 
    ]
}'
