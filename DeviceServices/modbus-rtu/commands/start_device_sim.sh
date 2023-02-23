#!/bin/sh

docker run --rm -d -e RUN_MODE=RTU --name modbus-sim iotechsys/modbus-sim:1.0
sleep 4
MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
(socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${MODBUS_SIM_ADDRESS}:50103) &
