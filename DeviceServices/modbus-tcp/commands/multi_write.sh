#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/modbus-sim -m \
'{   
  "metrics":
  [
    { "name": "Current",  "datatype": 6, "value":100  },
    { "name": "Power",  "datatype": 6, "value":50  },
    { "name": "Voltage",  "datatype": 6, "value":30  }
  ]
}'