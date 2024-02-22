#!/bin/sh

BASEDIR=$(dirname "$0")
docker run --rm -d -v $BASEDIR/../deployment/profiles:/profiles --name pymodbus-sim iotechsys/pymodbus-sim:1.0 --profile /profiles/modbus-sim-profile.json --comm serial --serial_over_tcp_port 50103
sleep 4
MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pymodbus-sim)
(socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${MODBUS_SIM_ADDRESS}:50103) &
