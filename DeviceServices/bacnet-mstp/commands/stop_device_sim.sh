#!/bin/sh

pkill -9 -f "socat.*virtualport" 2>/dev/null
docker kill bacnet-mstp-sim
