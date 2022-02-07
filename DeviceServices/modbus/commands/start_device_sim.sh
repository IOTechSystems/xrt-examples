#!/bin/sh

if [ "$RTU_MODE" = "true" ]; then
  docker run --rm -d -v $PWD/commands/rtu-sim.sh:/rtu-sim.sh --entrypoint /rtu-sim.sh --name modbus-sim --network=host iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
  export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
else
  export MODBUS_SIM_PORT=1502
  docker run --rm -d --name modbus-sim -p $MODBUS_SIM_PORT iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
  export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
fi
