#!/bin/sh

## This should be deleted -->
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
docker run --rm -d --name opc-ua-sim -e RUN_LDS=true --network=host -v $SCRIPT_DIR/../../../Simulators/opc-ua/:/scripts/ iotechsys/opc-ua-sim:1.0.dev -l /scripts/device-service-example.lua
## <--

#This should be uncommented
#docker run --rm -d --name opc-ua-sim -e RUN_LDS=true -p 49947 -p 4840 iotechsys/opc-ua-sim:1.0.dev -l /example-scripts/device-service-example.lua
