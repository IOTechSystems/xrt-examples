#!/bin/sh
# docker run -d returns as soon as the container is created, so check that it stays up

for i in 1 2 3 4 5; do
  sleep 1
  docker ps --format "{{.Names}}" | grep -qx ble-sim || { echo "Error: the simulator exited right after starting"; exit 1; }
done
