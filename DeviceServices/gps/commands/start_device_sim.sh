#!/bin/sh

GPS_SIM=iotechsys/gps-sim:1.0.0.dev
docker pull $GPS_SIM
docker run --rm -d --name gps-sim -p 2947:2947 --network=host $GPS_SIM
