#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus_tcp   -m \
    '{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
      "device": "modbus-device1",
      "interval": 500000,
      "name": "modbus-example-schedule1",
      "on_change": false,
      "resource": [
        "cell_1_tmp",
        "cell_2_tmp",
        "cell_3_tmp",
        "tmp_sf"
      ]
    }
}'
