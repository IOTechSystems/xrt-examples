#!/bin/sh
BASEDIR=$(dirname "$0")
docker run --rm -d -v $BASEDIR/../deployment/profiles:/profiles --name pymodbus-sim iotechsys/pymodbus-sim:1.0.5 --profile /profiles/modbus-sim-profile.json --port 1502
