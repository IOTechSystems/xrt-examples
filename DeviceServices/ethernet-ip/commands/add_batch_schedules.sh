#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client":"example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"ethernetip-sim-batch-sched1",
        "device":"ethernetip-sim",
        "resource":"DI1",
        "interval": 1000000,
        "on_change": false
      }
    },
    {
      "schedule": {
        "name":"ethernetip-sim-batch-sched2",
        "device":"ethernetip-sim",
        "resource":"DI2",
        "interval": 5000000,
        "on_change": false
      }
    },
    {
      "schedule": {
        "name":"ethernetip-sim-batch-sched3",
        "device":"ethernetip-sim",
        "resource":"DI3",
        "interval": 10000000,
        "on_change": false
      }
    }
  ]
}'
