#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/ethernetip-sim -m \
'{
  "metrics":
  [
    { "name": "DO1", "is_null": true },
    { "name": "DO2", "is_null": true },
    { "name": "DO3", "is_null": true },
    { "name": "DO4", "is_null": true },
    { "name": "VendorID", "is_null": true },
    { "name": "DeviceType", "is_null": true }
  ]
}'