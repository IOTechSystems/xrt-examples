#!/bin/sh
# Resolve the Dev3 BACnet/IP simulator's address via compose's embedded DNS
# and hand it to the stock `xrt` process as a BBMD address, then run it
# exactly as the public iotechsys/xrt image's own entrypoint does (see
# ../README.md for where this path convention comes from). Retries briefly
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

export BACNET_IP_DEV3_ADDRESS="$(resolve bacnet-sim-dev3)"

# Dev4 talks BACnet MSTP over a virtual serial link rather than IP - see the
# Dockerfile comment for why Dev3/Dev4 use different BACnet datalinks.
# bacnet-sim-dev4's own RUN_MODE=MSTP entrypoint exposes its simulated
# RS-485 bus over TCP:55000 for exactly this kind of network-bridged
# testing; bridge it to a local PTY that XRT::BACnetMSTPDeviceService's
# SerialInterface can open (its driver init fails if that path doesn't
# already exist, hence waiting for socat to create it below).
socat pty,link=/tmp/dev4-mstp,raw,echo=0 tcp:bacnet-sim-dev4:55000,retry=30,interval=1 &
i=0
while [ ! -e /tmp/dev4-mstp ] && [ "$i" -lt 30 ]; do
  sleep 1
  i=$((i + 1))
done

exec /opt/iotech/xrt/3.4/bin/xrt /opt/iotech/xrt/3.4/deployment/config
