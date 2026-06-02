#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/opc-ua-sim -m \
'{
 "metrics":[
   { "name": "ns=3;s=Counter:value", "datatype":10, "is_null": true }
  ]
}'
