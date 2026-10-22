#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client":"example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"canbus-example-schedule1",
        "device":"canbus-device",
        "resource":["Accelerator_Pedal_Position_1"],
        "on_change": true,
        "options": { "Cyclic": true },
        "interval": 1000000
      }
    },
    {
      "schedule": {
        "name":"canbus-example-schedule2",
        "device":"canbus-device",
        "resource":["Accelerator_Pedal_Position_2"],
        "on_change": true,
        "options": { "Cyclic": true },
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"canbus-example-schedule3",
        "device":"canbus-device",
        "resource":["Engine_Percent_Load_At_Current_S"],
        "on_change": true,
        "options": { "Cyclic": true },
        "interval": 10000000
      }
    }
  ]
}'
