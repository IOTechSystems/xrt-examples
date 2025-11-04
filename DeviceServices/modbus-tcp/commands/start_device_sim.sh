#!/bin/sh
BASEDIR=$(dirname "$0")
docker run --rm -d -v $BASEDIR/../deployment/profiles:/profiles --name pymodbus-sim pymodbus-sim:test --profile /profiles/modbus-sim-profile.json --port 1502 --instances 4
