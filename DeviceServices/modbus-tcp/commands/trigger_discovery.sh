#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"client1",
  "request_id": "a40c10f6-8489-401a-ac5f-5bd9942e995c",
  "op": "discovery:trigger",
  "options":
  { "TCP": [ { "Port": 1502, "StartAddress": "172.17.0.1", "EndAddress": "172.17.0.50"} ] },
  "type": "xrt.request:1.0"
}'