#!/bin/sh
mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/lua -m \
'{
  "schedule_status": "inactive"
}'
