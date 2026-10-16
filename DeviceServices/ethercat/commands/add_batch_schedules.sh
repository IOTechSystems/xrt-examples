#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client":"example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"ethercat-schedule1",
        "device":"XMC4800",
        "resource":["IN_GEN_BIT1"],
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"ethercat-schedule2",
        "device":"XMC4800",
        "resource":["IN_GEN_BIT2"],
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"ethercat-schedule3",
        "device":"XMC4800",
        "resource":["IN_GEN_BIT3"],
        "interval": 10000000
      }
    }
  ]
}'
