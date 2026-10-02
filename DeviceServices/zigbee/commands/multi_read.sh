#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/LED_light_strip -m \
'{
  "metrics":
  [
    { "name": "brightness", "is_null": true },
    { "name": "state", "is_null": true },
    { "name": "color_temp", "is_null": true }
  ]
}'