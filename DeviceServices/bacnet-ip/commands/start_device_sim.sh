#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LUA_SCRIPT="$SCRIPT_DIR/../../../Simulators/bacnet/device-service-example.lua"

docker run --rm -d --name=bacnet-ip-sim -e RUN_MODE=IP -v "$LUA_SCRIPT:/example-scripts/device-service-example.lua" iotechsys/bacnet-sim:2.2.7 --script /example-scripts/device-service-example.lua --instance 1234 --name BacnetSimulator
