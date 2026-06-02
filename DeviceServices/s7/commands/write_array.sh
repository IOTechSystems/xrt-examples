#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/s7-sim -m \
'{   
  "metrics":
  [
    { "name": "DB_1_I64_ARRAY", "datatype": 25, "value": [-29837, 29837, 77889988, 33443, 123456] }
  ]
}'