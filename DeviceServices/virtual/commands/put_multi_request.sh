#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/Virtual-Device -m \
'{   
  "metrics":
  [
    { "name": "StoreInt32Value", "value": 26, "datatype": 3 },
    { "name": "StoreFloat32Value", "value": 3.14, "datatype": 9 }
  ]
}'