#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/modbus-sim -m \
'{   
  "metrics":
  [
    { "name": "Current",  "datatype": 6, "is_null": true  },
    { "name": "Power",  "datatype": 6, "is_null": true  },
    { "name": "Voltage",  "datatype": 6, "is_null": true  }
  ]
}'

