#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/XMC4800 -m \
'{
  "metrics":
  [
    { "name": "OUT_GEN_BIT1", "value": true, "datatype": 11 },
    { "name": "OUT_GEN_BIT3", "value": true, "datatype": 11 },
    { "name": "OUT_GEN_BIT5", "value": true, "datatype": 11 },
    { "name": "OUT_GEN_BIT7", "value": true, "datatype": 11 }
  ]
}'