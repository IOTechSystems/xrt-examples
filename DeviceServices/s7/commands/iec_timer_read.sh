#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client:3.1.3.dev pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/s7-sim -m \
'{   
  "metrics":
  [
    { "name": "IEC_TIMER", "datatype": 14, "is_null": true }
  ]
}'