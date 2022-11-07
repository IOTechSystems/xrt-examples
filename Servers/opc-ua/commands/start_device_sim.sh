#!/bin/sh

S7_SIM=iotechsys/s7-sim:2.0
docker pull $S7_SIM
docker run --rm -d --name s7-sim --network=host $S7_SIM
