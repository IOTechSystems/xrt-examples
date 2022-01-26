#!/bin/sh

docker run --rm -d --name modbus-sim -e RUN_LDS=true --network=host -p 1502 iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
