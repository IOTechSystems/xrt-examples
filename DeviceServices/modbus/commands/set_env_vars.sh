#!/bin/sh

export XRT_PROFILE_DIR=$PWD/deployment/profiles/

if [ "$1" = "rtu" ]
then
  export RTU_MODE=true
  export XRT_STATE_DIR=$PWD/deployment/rtu/state/
else 
  export MODBUS_SIM_ADDRESS=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' modbus-sim)
  export MODBUS_SIM_PORT=1502
  export RTU_MODE=false
  export XRT_STATE_DIR=$PWD/deployment/tcp/state/
fi

export XRT_MQTT_BROKER=tcp://localhost:1883
export XRT_MQTT_USERNAME=""
export XRT_MQTT_PASSWORD=""
