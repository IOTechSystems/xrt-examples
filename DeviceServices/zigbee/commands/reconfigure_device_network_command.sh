#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/coordinator_device -m \
'{
  "metrics":
  [
    { "name": "reconfigure_device", "value": "0x7cb03eaa00a9b799", "datatype": 12 }
  ]
}'