#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/lua -m \
'{
 "metrics":[
   { "name": "int8", "is_null": true }
 ]
}'