#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ethernetip-sim -m \
'{
  "metrics":
  [
    { "name": "DO1", "is_null": true }
  ]
}'