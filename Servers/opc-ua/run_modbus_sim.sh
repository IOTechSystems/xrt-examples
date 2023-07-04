#!/bin/bash

docker run -it --network=host -v $(pwd)/deployment/profiles/:/profiles/ iotechsys/pymodbus-sim:1.0 --profile /profiles/CATL_BMS_profile.json --port 1502
