#!/bin/sh

socat -d -d -d -d pty,link=/tmp/master,raw,echo=0 pty,link=/tmp/slave,raw,echo=0 &
sleep 1
socat tcp-listen:50103,reuseaddr,fork file:/tmp/slave,nonblock,raw,echo=0 &
sleep 1

./modbus-simulator -protocol=RTU
