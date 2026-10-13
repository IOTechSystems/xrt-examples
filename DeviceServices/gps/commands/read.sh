#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/gps-sim -m \
'{
  "metrics":
  [
    { "name": "Date", "is_null": true }
  ]
}'