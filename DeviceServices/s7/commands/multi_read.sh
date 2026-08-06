#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/s7-sim -m \
'{   
  "metrics":
  [
    { "name": "DB_1_I8", "is_null": true },
    { "name": "DB_1_I16", "is_null": true },
    { "name": "DB_1_I32", "is_null": true },
    { "name": "DB_1_I64", "is_null": true },
    { "name": "DB_1_UI8", "is_null": true },
    { "name": "DB_1_UI16", "is_null": true },
    { "name": "DB_1_UI32", "is_null": true },
    { "name": "DB_1_UI64", "is_null": true },
    { "name": "DB_1_F32", "is_null": true },
    { "name": "DB_1_F64", "is_null": true },
    { "name": "DB_1_String_Test", "is_null": true }
  ]
}'
