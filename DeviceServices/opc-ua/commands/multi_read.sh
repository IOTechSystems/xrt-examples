#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/opc-ua-sim -m \
'{
 "metrics":[
   { "name": "ns=3;s=Counter:value",  "is_null": true},
   { "name": "ns=3;s=Random:value",   "is_null": true},
   { "name": "ns=3;s=Sawtooth:value", "is_null": true},
   { "name": "ns=3;s=Triangle:value", "is_null": true},
   { "name": "ns=3;s=Sinusoid:value", "is_null": true}
  ]
}'
