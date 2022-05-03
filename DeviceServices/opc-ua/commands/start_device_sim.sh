#!/bin/sh
OPC_UA_SIM=iotechsys/opc-ua-sim:1.1
docker pull $OPC_UA_SIM
docker run --rm -d --name opc-ua-sim -e RUN_LDS=true --network=host -p 49947 -p 4840 $OPC_UA_SIM -l /example-scripts/device-service-example.lua
