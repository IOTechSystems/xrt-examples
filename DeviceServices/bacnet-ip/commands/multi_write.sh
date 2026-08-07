#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/bacnet-ip-sim -m \
'{
 "metrics":[
   { "name": "analog_output_0:present-value", "datatype":9, "value":33.23},
   { "name": "analog_output_1:present-value", "datatype":9, "value":73.63}
  ]
}'
