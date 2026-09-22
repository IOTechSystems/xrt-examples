#!/bin/sh
# Resolve the two BACnet/IP simulator containers' addresses via compose's
# embedded DNS and hand them to the stock `xrt` process as BBMD addresses,
# then run it exactly as the public iotechsys/xrt image's own entrypoint
# does (see ../README.md for where this path convention comes from).
# Retries briefly in case this container starts before the simulator's
# DNS entry is up.
set -e

resolve () {
  addr=""
  i=0
  while [ -z "$addr" ] && [ "$i" -lt 30 ]; do
    addr="$(getent hosts "$1" | awk '{print $1}')"
    [ -n "$addr" ] || sleep 1
    i=$((i + 1))
  done
  echo "$addr"
}

export BACNET_IP_DEV3_ADDRESS="$(resolve bacnet-sim-dev3)"
export BACNET_IP_DEV4_ADDRESS="$(resolve bacnet-sim-dev4)"

exec /opt/iotech/xrt/3.4/bin/xrt /opt/iotech/xrt/3.4/deployment/config
