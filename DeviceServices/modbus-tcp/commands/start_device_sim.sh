#!/bin/sh

docker run --rm -d -v $PWD/deployment/profiles:/profiles --name pymodbus-sim iotechsys/pymodbus-sim:1.0 --profile /profiles/modbus-sim-profile.json --port 1502
