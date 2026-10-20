#!/bin/sh

# The example device connects to 192.168.50.7:20001, so give the simulator that address on its own docker network
# The network is only created if it does not exist yet, so the script can be run again after an earlier run
docker network inspect canbus-sim-net > /dev/null 2>&1 || docker network create --subnet 192.168.50.0/24 canbus-sim-net
docker run --rm -d --name canbus-sim --network canbus-sim-net --ip 192.168.50.7 iotechsys/canbus-sim:1.0
