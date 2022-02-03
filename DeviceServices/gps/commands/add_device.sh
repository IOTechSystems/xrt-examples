#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "device": "gps-sim",
  "device_info": 
  {
    "profileName": "GPS-Device"
  }  
}'
