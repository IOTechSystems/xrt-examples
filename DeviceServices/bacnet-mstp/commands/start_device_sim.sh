#!/bin/sh

docker run --rm -d --name=bacnet-mstp-sim -e RUN_MODE=MSTP iotechsys/bacnet-sim:2.0 --script /example-scripts/device-service-example.lua --instance 1234 --name BacnetSimulator
sleep 2
BACNET_MSTP_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-mstp-sim)
( socat pty,link=/tmp/virtualport,raw,echo=0 tcp:${BACNET_MSTP_SIM_ADDRESS}:55000 ) &
