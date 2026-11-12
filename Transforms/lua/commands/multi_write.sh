#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/lua -m \
'{
  "metrics":
  [
    { "name": "int8", "value": -120, "datatype": 1 },
    { "name": "uint64", "value": 9223372000000000000, "datatype": 8 },
    { "name": "float32", "value": 22.951, "datatype": 9 },
    { "name": "vector", "value": [ 44, 89, 12 ], "datatype": 23 }
  ]
}'