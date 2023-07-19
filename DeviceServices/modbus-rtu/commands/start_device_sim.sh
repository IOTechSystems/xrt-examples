#!/bin/sh

docker run --rm -d --name pymodbus-sim iotechsys/pymodbus-sim:1.0 --profile example_profiles/modbus-example-profile-2.0.json --comm serial --serial_over_tcp_port 50103
sleep 4
MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' pymodbus-sim)
(socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${MODBUS_SIM_ADDRESS}:50103) &
