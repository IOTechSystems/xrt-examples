#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{"schedule": {"name": "Virtual-Schedule", "device": "Virtual-Device", "resource": ["random_sbyte3"], "interval": 1000}, "client": "XRT Python Test", "request_id": "56ec754a-75af-4aed-bd24-b5bbbac889ce", "op": "schedule:add"}
'
