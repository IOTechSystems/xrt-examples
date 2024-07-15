#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus -m \
'{
  "client":"client1",
  "request_id": "a40c10f6-8489-401a-ac5f-5bd9942e995c",
  "op": "discovery:trigger",
  "options":
  { "RTU": [ { "Device": "/tmp/virtualport", "StartUnit": 1, "EndUnit": 10, "Baud": 19200, "Bits": "8-N-1" } ] },
  "type": "xrt.request:1.0"
}'