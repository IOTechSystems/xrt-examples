#!/bin/sh

docker run --rm -d --name=bacnet-sim -e RUN_MODE=IP iotechsys/bacnet-server:2.0 --script /example-scripts/device-service-example.lua --instance 1234 --name bacnet-sim
