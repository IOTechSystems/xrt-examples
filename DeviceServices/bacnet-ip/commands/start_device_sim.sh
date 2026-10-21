#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LUA_SCRIPT="$SCRIPT_DIR/../../../Simulators/bacnet/device-service-example.lua"

# Each simulator is a single BACnet device with its own device instance and device name
# bacnet-ip-sim is used by the single device example, bacnet-ip-sim-01..03 by the batch device example
start_sim ()
{
  docker run --rm -d --name=$1 -e RUN_MODE=IP -v "$LUA_SCRIPT:/example-scripts/device-service-example.lua" iotechsys/bacnet-sim:2.2.7 --script /example-scripts/device-service-example.lua --instance $2 --name $3
}

start_sim bacnet-ip-sim 1234 BacnetSimulator
start_sim bacnet-ip-sim-01 1235 BacnetSimulator01
start_sim bacnet-ip-sim-02 1236 BacnetSimulator02
start_sim bacnet-ip-sim-03 1237 BacnetSimulator03
