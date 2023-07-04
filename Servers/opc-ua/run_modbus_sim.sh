#!/bin/bash

docker run -it --network=host -v $(pwd)/modbus-sim/:/profiles/ iotechsys/pymodbus-sim:1.0 \
  --profile /profiles/CATL_BMS_profile.json  \
  --port 1502  \
  --defaults /profiles/default_values_CATL_BMS_profile.json \
  --script /profiles/set_values_script \
  --delay 1
