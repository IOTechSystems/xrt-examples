#!/bin/sh

docker run --rm -d --name opc-ua-sim -e RUN_LDS=true --network=host -p 49947 -p 4840 iotechsys/opc-ua-sim:1.0.dev -l /example-scripts/device-service-example.lua
