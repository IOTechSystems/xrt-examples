#!/bin/bash
# Resolves the Dev3 BACnet/IP simulator's address for XRT's BBMD config
# (BACNET_IP_DEV3_ADDRESS), bridges in Dev4's MSTP link, then runs XRT.
set -euo pipefail

# Until the main process is running, stop on SIGTERM (docker stop): as PID 1
# this script otherwise ignores it
trap 'exit 143' TERM INT

# Prints the address of host $1, waiting up to 30s for compose's embedded DNS
# to have it, in case this container starts before the simulator's.
resolve () {
  local addr="" i=0
  while [ -z "$addr" ] && [ "$i" -lt 30 ]; do
    addr="$(getent hosts "$1" | awk '{print $1}')" || true
    [ -n "$addr" ] || sleep 1
    i=$((i + 1))
  done
  if [ -z "$addr" ]; then
    echo "$1 not resolvable after 30s" >&2
    exit 1
  fi
  echo "$addr"
}

BACNET_IP_DEV3_ADDRESS="$(resolve bacnet-sim-dev3)"
export BACNET_IP_DEV3_ADDRESS

# Dev4 talks BACnet MSTP over a virtual serial link, bridged to its simulator
# over TCP. The device service holds the link open, so if socat or the
# simulator goes away, a new link won't help it: this exits instead, for the
# container's restart policy to start everything again.
# socat's retry doesn't cover the simulator's name not resolving yet
resolve bacnet-sim-dev4 >/dev/null
socat pty,link=/tmp/dev4-mstp,raw,echo=0 tcp:bacnet-sim-dev4:55000,retry=30,interval=1 &
socat_pid=$!
i=0
while [ ! -e /tmp/dev4-mstp ]; do
  if [ "$i" -ge 30 ] || ! kill -0 "$socat_pid" 2>/dev/null; then
    echo "No MSTP link to bacnet-sim-dev4 (socat exited, or 30s passed)" >&2
    exit 1
  fi
  sleep 1
  i=$((i + 1))
done

"${XRT}/bin/xrt" "${XRT_DEPLOYMENT_DIR}/config" &
main_pid=$!
trap 'kill -TERM "$main_pid" 2>/dev/null' TERM INT

# Wait for either to exit, then stop the other and exit with its status
status=0
wait -n "$socat_pid" "$main_pid" || status=$?
if ! kill -0 "$socat_pid" 2>/dev/null; then
  echo "MSTP link to bacnet-sim-dev4 closed" >&2
  status=1
fi
kill -TERM "$main_pid" "$socat_pid" 2>/dev/null || true
wait "$main_pid" || true
exit "$status"
