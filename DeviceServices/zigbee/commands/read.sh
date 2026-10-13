#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/LED_light_strip -m \
'{
  "metrics":
  [
    { "name": "state", "is_null": true }
  ]
}'