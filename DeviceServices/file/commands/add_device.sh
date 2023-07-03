#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/${FILE_SERVICE} -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "file-example",
  "device_info": {
    "profileName": "file-example",
    "protocols": {
      "FILE": {
        "Directory": "${FILE_DIR_PATH}"
      }
    }
  }  
}'
