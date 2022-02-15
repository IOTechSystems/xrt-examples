#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "device": "ethernetip-sim",
  "resource": [
      "DO1",
      "DO2",
      "DO1",
      "DO2", 
      "VendorID",
      "DeviceType" 
    ]
}'
