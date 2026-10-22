#!/bin/sh

# ethernetip-sim is used by the single device example, ethernetip-sim-01..03 by the batch device example.
# Each device needs its own simulator, as the device service does not support multiple devices at the same IP address.
for SIM in ethernetip-sim ethernetip-sim-01 ethernetip-sim-02 ethernetip-sim-03
do
  docker run -i -d --rm --name=$SIM iotechsys/ethernetip-sim:1.0
done
