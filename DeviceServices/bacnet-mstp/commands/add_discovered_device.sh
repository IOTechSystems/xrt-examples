#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_mstp_device_service/request -m \
'{
  "client": "example",
  "request_id":"1060",
  "op": "device:add",
  "device": "bacnet-mstp-sim",
  "device_info":  {
    "protocols":{
      "BACnet-MSTP":{
        "DeviceInstance": "1234"
      }
    }
  }
}'
