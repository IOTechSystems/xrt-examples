#!/bin/sh

docker run --rm -d --name pymodbus-sim iotechsys/pymodbus-sim:1.0.5 --profile example_profiles/modbus-example-profile-3.0.json --port 1502
