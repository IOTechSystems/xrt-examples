#!/bin/sh

docker run --rm -d --name modbus-sim -e RUN_LDS=true --network=host -p 1502 iotechsys/modbus-sim:1.0.dev -l /example-scripts/device-service-example.lua
