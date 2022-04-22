#!/bin/sh

GPS_SIM=knowhowlab/gpsd-nmea-simulator

docker run --rm -d --name gps-sim -p 2947:2947 $GPS_SIM
