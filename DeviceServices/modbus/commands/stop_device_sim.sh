#!/bin/sh

if [ "$1" = "rtu" ] then
  kill -9 $(ps | grep "socat" | awk '{ print $1 }')
fi
docker kill modbus-sim
