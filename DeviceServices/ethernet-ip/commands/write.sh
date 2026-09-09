#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ethernetip-sim -m \
'{
  "metrics":
  [
    { "name": "DI1", "value": "true", "datatype": 11 }
  ]
}'