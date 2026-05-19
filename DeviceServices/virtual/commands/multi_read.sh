#!/bin/sh

docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/Virtual-Device -m \
'{   
 "metrics":[
   { "name": "SineWave", "datatype":10, "is_null": true },
   { "name": "SineWaveWithOffsetAndPhase", "datatype":10, "is_null": true }
 ] 
}'
