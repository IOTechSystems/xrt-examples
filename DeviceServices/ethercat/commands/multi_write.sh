#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/EL7037 -m \
'{
  "metrics":
  [
    { "name": "Enable micro increments", "value": false, "datatype": 11 },
    { "name": "Reversion of rotation", "value": true, "datatype": 11 }
  ]
}'