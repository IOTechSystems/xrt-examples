#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/netHAT -m \
'{
  "metrics":
  [
    { "name": "InputUint32", "is_null": true },
    { "name": "InputUint16-offset-5", "is_null": true }
  ]
}'