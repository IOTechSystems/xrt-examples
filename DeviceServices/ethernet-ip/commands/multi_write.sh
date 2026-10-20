#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ethernetip-sim -m \
'{
  "metrics":
  [
    { "name": "DO1", "value": false, "datatype": 11 },
    { "name": "DO2", "value": true, "datatype": 11 },
    { "name": "DO3", "value": true, "datatype": 11 },
    { "name": "DO4", "value": false, "datatype": 11 }
  ]
}'