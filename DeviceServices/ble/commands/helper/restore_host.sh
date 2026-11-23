#!/bin/sh
# Stops the simulator and restores what release_host.sh changed on the host.
# Entries that fail to restore are kept in $HOST_STATE so that this script can be run again.

. "$(dirname "$0")/common.sh"

# The entries are run with sudo, so only trust a file owned by the current user
if [ -L "$HOST_STATE" ] || { [ -e "$HOST_STATE" ] && [ ! -O "$HOST_STATE" ]; }; then
  echo "Error: $HOST_STATE must be a regular file owned by the current user"
  exit 1
fi

# The host is only restored once the container is confirmed gone, otherwise $HOST_STATE is kept
sim_exists
case $? in
  0)
    docker rm -f ble-sim > /dev/null 2>&1 || { echo "Error: could not stop ble-sim, the host was not restored"; exit 1; }
    echo "Stopped ble-sim" ;;
  2)
    echo "Error: could not query docker, the host was not restored"
    exit 1 ;;
esac

# The simulator's BlueZ and virtual controllers must be gone before the host ones come back
tries=0
while :; do
  sim_exists
  status=$?
  [ $status -eq 1 ] && break
  if [ $status -eq 2 ]; then
    echo "Error: could not query docker, the host was not restored"
    exit 1
  fi
  tries=$((tries + 1))
  if [ $tries -gt 30 ]; then
    echo "Error: ble-sim is still present after 15 s, the host was not restored"
    exit 1
  fi
  sleep 0.5
done

# Restore what start_device_sim.sh changed on the host
if [ -f $HOST_STATE ]; then
  # Entries that fail to restore are kept in $HOST_STATE so that this script can be run again
  remaining=""
  while read -r action driver device; do
    [ "$action" = unbind ] || continue
    case $driver in /sys/bus/*/drivers/*) ;; *) continue ;; esac
    case $driver$device in *..*|*[!A-Za-z0-9/:._-]*) continue ;; esac
    if [ -e "$driver/$device" ]; then
      continue  # already bound, nothing to restore
    fi
    echo "Restoring $device ($(basename "$driver"))"
    if ! echo "$device" | sudo tee "$driver/bind" > /dev/null; then
      echo "Error: could not restore $device"
      remaining="$remaining
$action $driver $device"
    fi
  done < $HOST_STATE
  # bluetooth-mask: the service was masked by start, bluetooth-start: it was running before and is restarted
  unmasked=true
  if grep -qx bluetooth-mask $HOST_STATE; then
    echo "Unmasking host bluetooth service"
    if ! sudo systemctl unmask --runtime bluetooth; then
      echo "Error: could not unmask the bluetooth service"
      unmasked=false
      remaining="$remaining
bluetooth-mask"
    fi
  fi
  if grep -qx bluetooth-start $HOST_STATE; then
    if $unmasked && echo "Restarting host bluetooth service" && sudo systemctl start bluetooth; then
      :
    else
      echo "Error: could not restart the bluetooth service"
      remaining="$remaining
bluetooth-start"
    fi
  fi
  if [ -n "$remaining" ]; then
    printf '%s\n' "$remaining" | sed '1{/^$/d}' > $HOST_STATE
    echo "Error: the host was not fully restored, run stop_device_sim.sh again to retry"
    exit 1
  fi
  rm -f $HOST_STATE
fi
