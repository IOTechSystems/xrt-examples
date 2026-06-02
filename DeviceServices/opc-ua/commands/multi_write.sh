#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/opc-ua-sim -m \
'{
 "metrics":[
   { "name": "ns=2;s=Int64:value", "datatype":4, "value":42},
   { "name": "ns=2;s=Float:value", "datatype":9, "value":123.456},
   { "name": "ns=2;s=String:value", "datatype":12, "value":"Example string"}
  ]
}'
