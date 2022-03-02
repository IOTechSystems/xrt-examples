#!/bin/sh

if [ "$1" = "rtu" ] 
then
  docker run --rm -d -v $PWD/commands/rtu-sim.sh:/rtu-sim.sh --entrypoint /rtu-sim.sh --name modbus-sim iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
  sleep 6
  MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
  (socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${MODBUS_SIM_ADDRESS}:50103) &
else
  export MODBUS_SIM_PORT=1502
  docker run --rm -d --name modbus-sim -p $MODBUS_SIM_PORT iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
  export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
fi
