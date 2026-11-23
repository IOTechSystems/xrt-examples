#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/${FILE_SERVICE} -m \
'{
  "client":"example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"file-schedule1",
        "device":"file-example",
        "resource":"file_string",
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"file-schedule2",
        "device":"file-example",
        "resource":"file_int32",
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"file-schedule3",
        "device":"file-example",
        "resource":"file_uint32",
        "interval": 10000000
      }
    }
  ]
}'
