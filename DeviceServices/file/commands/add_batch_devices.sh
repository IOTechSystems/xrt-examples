#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/${FILE_SERVICE} -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "file-example-01",
      "device_info": {
        "profileName": "file-example",
        "protocols": {
          "FILE": {
            "Directory": "'"${FILE_DIR_PATH}"'"
          }
        }
      }
    },
    {
      "device": "file-example-02",
      "device_info": {
        "profileName": "file-example",
        "protocols": {
          "FILE": {
            "Directory": "'"${FILE_DIR_PATH}"'"
          }
        }
      }
    },
    {
      "device": "file-example-03",
      "device_info": {
        "profileName": "file-example",
        "protocols": {
          "FILE": {
            "Directory": "'"${FILE_DIR_PATH}"'"
          }
        }
      }
    }
  ]
}'
