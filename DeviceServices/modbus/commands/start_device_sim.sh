#!/bin/sh

if [ "$RTU_MODE" = "true" ]
then
    export MODBUS_SIM_ADDRESS="/dev/ttyUSB0"
    docker run --rm -d --name modbus-sim --network=host iotechsys/dev-testing-edgex-modbus-simulator:2.0.0 -protocol=RTU
    # todo: get this running and test with new code
else
    export MODBUS_SIM_PORT=1502
    docker run --rm -d --name modbus-sim -p $MODBUS_SIM_PORT iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
    export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
fi
