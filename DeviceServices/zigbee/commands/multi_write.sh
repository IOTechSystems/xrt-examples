#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/LED_light_strip -m \
'{
  "metrics":
  [
    { "name": "brightness", "value": 254, "datatype": 9 }
    { "name": "transition", "value": 1, "datatype": 9 }
    { "name": "state", "value": true, "datatype": 11 }
    { "name": "color_hs", "value": {"hue": 100, "saturation": 100}, "datatype": 19 }
  ]
}'

"brightness": 254,
    "transition": 1,
    "state": true,
    "color_hs": {"hue": 100, "saturation": 100}