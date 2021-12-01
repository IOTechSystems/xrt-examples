#!/bin/sh

docker run --rm -d --name=bacnet-ip-sim -e RUN_MODE=IP iotechsys/bacnet-server:2.0 --script /help/sim_script.lua --instance 1234 --name bacnet-ip-sim