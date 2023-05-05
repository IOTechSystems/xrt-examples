#!/bin/sh

cd ..
./scripts/build.sh
./simulator -protocol=TCP -test=true
