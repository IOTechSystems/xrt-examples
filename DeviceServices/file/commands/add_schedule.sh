#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${FILE_SERVICE} -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"file-schedule1",
    "device":"file-example",
    "resource":"file_string",
    "interval": 1000000
  }
}'
