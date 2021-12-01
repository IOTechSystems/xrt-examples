#!/bin/sh

docker run --rm -d --name=bacnet-ip-sim -e RUN_MODE=IP iotechsys/bacnet-server:2.0 --script /help/sim_script.lua --instance 1234 --name bacnet-ip-sim

BACNET_MSTP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-ip-sim)

( socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${BACNET_MSTP_SIM_ADDRESS}:55000 ) &