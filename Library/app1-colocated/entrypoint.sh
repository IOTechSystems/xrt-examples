#!/bin/sh
# Resolve the two BACnet/IP simulator containers' addresses via compose's
# embedded DNS and hand them to spg_demo as BBMD addresses. Retries briefly
# in case this container starts before the simulator's DNS entry is up.
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

export BACNET_IP_DEV1_ADDRESS="$(resolve bacnet-sim-dev1)"
export BACNET_IP_DEV2_ADDRESS="$(resolve bacnet-sim-dev2)"

exec ./spg_demo
