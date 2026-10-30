#!/bin/sh
mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/lua -m \
'{
  "transform": "ddata_transform",
  "status": "inactive"
}'
