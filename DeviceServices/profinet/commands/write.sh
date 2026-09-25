#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/netHAT -m \
'{
  "metrics":
  [
    { "name": "OutputFloat32", "value": "-27.8", "datatype": 9 }
  ]
}'