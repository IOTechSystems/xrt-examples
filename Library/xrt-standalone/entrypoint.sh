#!/bin/sh
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

# Dev4 talks BACnet MSTP over a virtual serial link
socat pty,link=/tmp/dev4-mstp,raw,echo=0 tcp:bacnet-sim-dev4:55000,retry=30,interval=1 &
i=0
while [ ! -e /tmp/dev4-mstp ] && [ "$i" -lt 30 ]; do
  sleep 1
  i=$((i + 1))
done

exec /opt/iotech/xrt/3.4/bin/xrt /opt/iotech/xrt/3.4/deployment/config
