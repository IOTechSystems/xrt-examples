#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device",
  "resource": [
      "SineWave",
      "SineWaveWithOffsetAndPhase"
    ]
}'
