#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-rtu -m \
'{
  "client":"xrt modbus-rtu example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"modbus-rtu-schedule1",
        "device":"modbus-sim",
        "resource":"Current",
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"modbus-rtu-schedule2",
        "device":"modbus-sim",
        "resource":"Energy",
        "interval": 10000000
      }
    },
    {
      "schedule": {
        "name":"modbus-rtu-schedule3",
        "device":"modbus-sim",
        "resource":"Power",
        "interval": 20000000
      }
    }
  ]
}'
