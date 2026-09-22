#!/bin/sh
# Resolve the Dev1 BACnet/IP simulator's address via compose's embedded DNS
# and hand it to spg_demo as a BBMD address. Retries briefly in case this
# container starts before the simulator's DNS entry is up.
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

# Dev2 talks BACnet MSTP over a virtual serial link rather than IP - see the
# Dockerfile comment for why Dev1/Dev2 use different BACnet datalinks.
# bacnet-sim-dev2's own RUN_MODE=MSTP entrypoint exposes its simulated
# RS-485 bus over TCP:55000 for exactly this kind of network-bridged
# testing; bridge it to a local PTY that XRT::BACnetMSTPDeviceService's
# SerialInterface can open (main.c fails driver init if that path doesn't
# already exist, hence waiting for socat to create it below).
socat pty,link=/tmp/dev2-mstp,raw,echo=0 tcp:bacnet-sim-dev2:55000,retry=30,interval=1 &
i=0
while [ ! -e /tmp/dev2-mstp ] && [ "$i" -lt 30 ]; do
  sleep 1
  i=$((i + 1))
done

exec ./spg_demo
