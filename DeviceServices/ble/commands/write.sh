#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ble-sim -m \
'{
  "metrics":
  [
    { "name": "Static", "value": 64, "datatype": 7 }
  ]
}'