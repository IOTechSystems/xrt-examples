#!/bin/sh

HOST_STATE=/tmp/ble-sim-host-state

docker kill ble-sim > /dev/null 2>&1 && echo "Stopped ble-sim"

# Restore what start_device_sim.sh changed on the host
if [ -f $HOST_STATE ]; then
  # The simulator's BlueZ and virtual controllers must be gone before the host ones come back
  timeout 15 sh -c 'while docker ps -a --format "{{.Names}}" | grep -qx ble-sim; do sleep 0.5; done'
  grep "^unbind " $HOST_STATE | while read -r action driver device; do
    echo "Restoring $device ($(basename $driver))"
    echo $device | sudo tee $driver/bind > /dev/null
  done
  if grep -qx bluetooth $HOST_STATE; then
    echo "Restarting host bluetooth service"
    sudo systemctl unmask --runtime bluetooth && sudo systemctl start bluetooth
  fi
  rm -f $HOST_STATE
fi
