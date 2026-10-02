#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/coordinator_device -m \
'{
  "metrics":
  [
    { "name": "backup", "is_null": true }
  ]
}'