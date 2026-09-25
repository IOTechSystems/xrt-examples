#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/EL7037 -m \
'{
  "metrics":
  [
    { "name": "Disable filter", "value": false, "datatype": 11 }
  ]
}'