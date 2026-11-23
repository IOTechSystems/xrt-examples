#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client":"xrt virtual example",
  "request_id": "1030",
  "op": "schedule:add_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    {
      "schedule": {
        "name":"virtual-schedule1",
        "device":"Virtual-Device",
        "resource":["RandomInt8","CountingUpFloat32"],
        "interval": 5000000
      }
    },
    {
      "schedule": {
        "name":"virtual-schedule2",
        "device":"Virtual-Device",
        "resource":["SineWaveWithOffsetAndPhase","TriangleWaveWithOffsetAndPhase"],
        "interval": 10000000
      }
    },
    {
      "schedule": {
        "name":"virtual-schedule3",
        "device":"Virtual-Device",
        "resource":["SquareWaveWithOffsetAndPhase","RandomFloat64"],
        "interval": 20000000
      }
    }
  ]
}'
