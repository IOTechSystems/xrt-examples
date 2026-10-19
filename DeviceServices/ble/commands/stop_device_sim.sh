#!/bin/sh

docker kill ble-sim
$(dirname "$0")/helper/restore_host.sh
