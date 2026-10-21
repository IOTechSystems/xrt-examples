#!/bin/sh

docker kill canbus-sim canbus-sim-01 canbus-sim-02 canbus-sim-03
docker network rm canbus-sim-net
