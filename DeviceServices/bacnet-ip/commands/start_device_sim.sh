#!/bin/sh

docker run --rm -d --name=bacnet-ip-sim -e RUN_MODE=IP iotechsys/bacnet-sim:2.2 --script /example-scripts/device-service-example.lua --instance 1234 --name BacnetSimulator
