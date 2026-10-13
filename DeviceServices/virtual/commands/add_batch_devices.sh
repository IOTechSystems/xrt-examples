#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client": "xrt virtual example",
  "request_id": "1010",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "Virtual-Device",
      "device_info":  {
        "profileName": "device-virtual",
        "protocols":{
          "Virtual": {}
        }
      }
    },
    {
      "device": "Virtual-Device-02",
      "device_info":  {
        "profileName": "device-virtual",
        "protocols":{
          "Virtual": {}
        }
      }
    },
    {
      "device": "Virtual-Device-03",
      "device_info":  {
        "profileName": "device-virtual",
        "protocols":{
          "Virtual": {}
        }
      }
    }
  ]
}'
