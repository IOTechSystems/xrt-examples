#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client":"xrt bacnet-ip example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"bacnet-ip-schedule1",
        "device":"bacnet-ip-sim",
        "resource":["IOTech BACnet Simulator:system-status","IOTech BACnet Simulator:local-time"],
        "interval": 2000000
      }
    },
    {
      "schedule": {
        "name":"bacnet-ip-schedule2",
        "device":"bacnet-ip-sim",
        "resource":["analog_output_0:present-value"],
        "interval": 10000000
      }
    },
    {
      "schedule": {
        "name":"bacnet-ip-schedule3",
        "device":"bacnet-ip-sim",
        "resource":["analog_output_1:present-value"],
        "interval": 20000000
      }
    }
  ]
}'
