#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/modbus-sim -m \
'{   
  "metrics":
  [
    { "name": "Current", "value": 100, "datatype": 6 },
    { "name": "Power", "value": 50, "datatype": 6 },
    { "name": "Voltage", "value": 30, "datatype": 6 }    
  ]
}'