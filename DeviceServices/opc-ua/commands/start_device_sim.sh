#!/bin/sh

VER=1.2
OPC_UA_SIM=iotechsys/opc-ua-sim:$VER
OPC_UA_LDS=iotechsys/opc-ua-lds:$VER

docker pull $OPC_UA_LDS
docker pull $OPC_UA_SIM

docker run --rm -d --network=host --name opc-ua-lds $OPC_UA_LDS
docker run --rm -d --network=host --name opc-ua-sim $OPC_UA_SIM -l /example-scripts/simulation.lua --discovery-url=opc.tcp://$(hostname):4840
