#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/file-example -m \
'{   
  "metrics":
  [
    { "name": "file_string", "datatype": 12, "is_null": true }
  ]
}'