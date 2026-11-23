#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/${FILE_SERVICE} -m \
'{
  "client": "example",
  "request_id": "1033",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "pattern": ".*"
}'
