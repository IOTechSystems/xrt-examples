#!/bin/sh

# A simulator serves a single client, so each device has its own simulator and address
# canbus-sim is used by the single device example (the example device connects to 192.168.50.7:20001), canbus-sim-01..03 by the batch device example
# The network is only created if it does not exist yet, so the script can be run again after an earlier run
docker network inspect canbus-sim-net > /dev/null 2>&1 || docker network create --subnet 192.168.50.0/24 canbus-sim-net

start_sim ()
{
  docker run --rm -d --name $1 --network canbus-sim-net --ip $2 iotechsys/canbus-sim:1.0
}

start_sim canbus-sim 192.168.50.7
start_sim canbus-sim-01 192.168.50.8
start_sim canbus-sim-02 192.168.50.9
start_sim canbus-sim-03 192.168.50.10
