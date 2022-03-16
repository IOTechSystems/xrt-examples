#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "device": "gps-sim",
  "device_info": 
  {
    "profileName": "GPS-Device",
    "protocols": 
    {
      "GPS": 
      {
        "GpsdConnTimeoutMS": 2000,
        "GpsdConnTimeoutS": 3,
        "GpsdHostname": "0.0.0.0",
        "GpsdMode": "poll",
        "GpsdPort": 2947,
        "GpsdRequestTimeout": 5000,
        "GpsdRetries": 5
      }
    }
  }  
}'
