#!/bin/sh

if [ "$RTU_MODE" = "true" ]; then
  kill -9 $(ps | grep "socat" | awk '{ print $1 }')
fi
  docker kill modbus-sim
