#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_mstp_device_service/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "bacnet-mstp-sim",
  "device_info":  {
    "profile": "bacnet-mstp-sim-profile",
    "protocols":{
      "BACnet-MSTP":{
        "DeviceInstance": "1234"
      }
    }
  }
}'
