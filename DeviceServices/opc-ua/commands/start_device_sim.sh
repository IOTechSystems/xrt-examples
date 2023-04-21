#!/bin/sh

VER=1.2.0.dev-x86_64
OPC_UA_SIM=iotechsys/opc-ua-sim:$VER
OPC_UA_LDS=iotechsys/opc-ua-lds:$VER

# docker pull $OPC_UA_LDS
# docker pull $OPC_UA_SIM

docker network create test

docker run --rm -d --network=test --name opc-ua-lds $OPC_UA_LDS

LDS_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' opc-ua-lds)

echo $LDS_ADDRESS

docker run --rm -it --network=test --name opc-ua-sim $OPC_UA_SIM -l /example-scripts/simulation.lua

#LDS_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' opc-ua-lds)

#docker run --rm -d --name opc-ua-sim $OPC_UA_SIM -l /example-scripts/simulation.lua --discovery-url=opc.tpc://{$LDS_ADDRESS}:4840
