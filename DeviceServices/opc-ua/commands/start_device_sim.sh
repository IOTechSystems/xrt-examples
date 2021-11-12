#!/bin/sh

docker run --rm -d --name opc-ua-sim -e RUN_LDS=true -p 49947 -p 4840 iotechsys/opc-ua-sim:1.0.dev
