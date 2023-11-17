#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "device": "test_alarm",
  "resource": "alarm",
  "client": "alarm test",
  "request_id": "ba65b47d-a842-4ee4-b992-7e5a662befa0",
  "op": "event:deregister"
}'
