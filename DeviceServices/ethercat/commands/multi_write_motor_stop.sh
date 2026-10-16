#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/EL7037 -m \
'{
  "metrics":
  [
    { "name": "Velocity - STM Velocity - PDO", "value": 0, "datatype": 2 }
  ]
}'