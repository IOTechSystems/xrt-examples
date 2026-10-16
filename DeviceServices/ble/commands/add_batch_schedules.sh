#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ble -m \
'{
  "client": "xrt ble example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"ble-sim-schedule1",
        "device":"ble-sim",
        "resource":["Counter"],
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"ble-sim-schedule2",
        "device":"ble-sim",
        "resource":["Random"],
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"ble-sim-schedule3",
        "device":"ble-sim",
        "resource":["Sawtooth"],
        "interval": 10000000
      }
    }
  ]
}'
