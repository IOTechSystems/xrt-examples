#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/opc_ua -m \
'{
  "client":"example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"opc-ua-sim-schedule1",
        "device":"opc-ua-sim",
        "resource":"ns=3;s=Random:value",
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"opc-ua-sim-schedule2",
        "device":"opc-ua-sim",
        "resource":"ns=3;s=Sawtooth:value",
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"opc-ua-sim-schedule3",
        "device":"opc-ua-sim",
        "resource":"ns=3;s=Triangle:value",
        "interval": 10000000
      }
    }
  ]
}'
