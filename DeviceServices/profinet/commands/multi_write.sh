#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/netHAT -m \
'{
  "metrics":
  [
    { "name": "OutputUint8", "value": "17", "datatype": 5 },
    { "name": "OutputUint32-offset-20", "value": "87500", "datatype": 7 }
  ]
}'