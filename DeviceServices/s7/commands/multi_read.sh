#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/s7-sim -m \
'{   
  "metrics":
  [
    { "name": "DB_1_I8", "datatype": 1, "is_null": true },
    { "name": "DB_1_I16", "datatype": 2, "is_null": true },
    { "name": "DB_1_I32", "datatype": 3, "is_null": true },
    { "name": "DB_1_I64", "datatype": 4, "is_null": true },
    { "name": "DB_1_UI8", "datatype": 5, "is_null": true },
    { "name": "DB_1_UI16", "datatype": 6, "is_null": true },
    { "name": "DB_1_UI32", "datatype": 7, "is_null": true },
    { "name": "DB_1_UI64", "datatype": 8, "is_null": true },
    { "name": "DB_1_F32", "datatype": 9, "is_null": true },
    { "name": "DB_1_F64", "datatype": 10, "is_null": true },
    { "name": "DB_1_String_Test", "datatype": 12, "is_null": true }
  ]
}'
