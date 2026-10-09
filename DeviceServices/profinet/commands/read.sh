#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/netHAT -m \
'{
  "metrics":
  [
    { "name": "InputUint8", "is_null": true }
  ]
}'