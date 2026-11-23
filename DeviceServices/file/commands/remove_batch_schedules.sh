#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/${FILE_SERVICE} -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "file-schedule1",
    "file-schedule2",
    "file-schedule3"
  ]
}'
