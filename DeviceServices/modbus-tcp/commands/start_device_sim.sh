#!/bin/sh

docker run --rm -d --name pymodbus-sim iotechsys/pymodbus-sim:1.0 --profile example_profiles/modbus-example-profile-2.1.json --port 1502
