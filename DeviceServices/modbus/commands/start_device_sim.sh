#!/bin/sh

if ( $RTU_MODE == "true") then

<!-- todo: set Modbus Device address and port here and use later -->

    docker run --rm -d --name modbus-sim --network=host -p 1502 iotechsys/dev-testing-edgex-modbus-simulator:2.0.0
else

<!-- todo: set Modbus Device address here and use later -->

    docker run --rm -d --name modbus-sim --network=host iotechsys/dev-testing-edgex-modbus-simulator:2.0.0 -protocol=RTU
    #<-- todo: verify that this approach works or whether we need socat commands -->
fi