#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client":"xrt modbus-tcp example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"modbus-tcp-schedule1",
        "device":"modbus-sim",
        "resource":"Current",
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"modbus-tcp-schedule2",
        "device":"modbus-sim",
        "resource":"Energy",
        "interval": 10000000
      }
    },
    {
      "schedule": {
        "name":"modbus-tcp-schedule3",
        "device":"modbus-sim",
        "resource":"Power",
        "interval": 20000000
      }
    }
  ]
}'
