#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/XMC4800 -m \
'{
  "metrics":
  [
    { "name": "IN_GEN_BIT1", "is_null": true },
    { "name": "IN_GEN_BIT2", "is_null": true }
  ]
}'