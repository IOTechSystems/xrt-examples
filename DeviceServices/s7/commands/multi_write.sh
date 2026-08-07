#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/s7-sim -m \
'{   
  "metrics":
  [
    { "name": "DB_1_I8", "datatype": 1, "value": -126 },
    { "name": "DB_1_I16", "datatype": 2, "value": -1234 },
    { "name": "DB_1_I32", "datatype": 3, "value": -123456 },
    { "name": "DB_1_I64", "datatype": 4, "value": -42 },
    { "name": "DB_1_UI8", "datatype": 5, "value": 254 },
    { "name": "DB_1_UI16", "datatype": 6, "value": 12345 },
    { "name": "DB_1_UI32", "datatype": 7, "value": 54321 },
    { "name": "DB_1_UI64", "datatype": 8, "value": 987654321 },
    { "name": "DB_1_F32", "datatype": 9, "value": 43.345 },
    { "name": "DB_1_F64", "datatype": 10, "value": 123.321 },
    { "name": "DB_1_String_Test", "datatype": 12, "value": "Example" }
  ]
}'