#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ble-sim -m \
'{
  "metrics":
  [
    { "name": "Counter", "is_null": true },
    { "name": "Random", "is_null": true },
    { "name": "Sawtooth", "is_null": true },
    { "name": "Sinusoid", "is_null": true },
    { "name": "Square", "is_null": true },
    { "name": "Triangle", "is_null": true },
    { "name": "Static", "is_null": true },
  ]
}'