#!/bin/sh

docker run --rm -d -p 1502:1502 --name pymodbus-sim iotechsys/pymodbus-sim:1.1 --profile example_profiles/modbus-example-profile-3.0.json --port 1502

