#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/XMC4800 -m \
'{
  "metrics":
  [
    { "name": "OUT_GEN_BIT1", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT2", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT3", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT4", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT5", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT6", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT7", "value": false, "datatype": 11 },
    { "name": "OUT_GEN_BIT8", "value": false, "datatype": 11 }
  ]
}'