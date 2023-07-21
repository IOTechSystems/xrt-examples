#!/bin/sh

kill -9 $(ps | grep "socat" | awk '{ print $1 }')

docker kill pymodbus-sim
