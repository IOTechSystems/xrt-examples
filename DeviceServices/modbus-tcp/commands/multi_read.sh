#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/modbus-sim -m \
'{   
  "metrics":
  [
    { "name": "Current", "is_null": true  },
    { "name": "Power", "is_null": true  },
    { "name": "Voltage", "is_null": true  }
  ]
}'

