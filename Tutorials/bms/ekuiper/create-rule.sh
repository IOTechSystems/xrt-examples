#!/bin/sh
# Creates:
#  - the rack01 configuration of the opcua source, which subscribes to rack-01's module temperatures
#  - the rack_01 stream, which reads them through the opcua source plugin
#  - the rack_01_average_temperature rule, which publishes their average over a 30 s sliding window
#    to the bess/ekuiper/rack-01 topic for the Alarm Service

set -e

curl -sf -X PUT http://localhost:59720/metadata/sources/opcua/confKeys/rack01 \
  -H 'Content-Type: application/json' \
  -d '{
    "server": "opc.tcp://alarm-service:4840",
    "sparkplugNs": 3,
    "nodePrefix": "bess-node/rack-01",
    "metrics": ["module-1-temperature", "module-2-temperature"]
  }'
echo "Source configuration rack01 is created."

curl -sf -X POST http://localhost:59720/streams \
  -H 'Content-Type: application/json' \
  -d '{
    "sql": "CREATE STREAM rack_01() WITH (FORMAT=\"json\", TYPE=\"opcua\", CONF_KEY=\"rack01\")"
  }'
echo

curl -sf -X POST http://localhost:59720/rules \
  -H 'Content-Type: application/json' \
  -d '{
    "id": "rack_01_average_temperature",
    "sql": "SELECT (last_value(`module-1-temperature`, true) + last_value(`module-2-temperature`, true)) / 2 AS averageTemperature FROM rack_01 GROUP BY SLIDINGWINDOW(ss, 30)",
    "actions": [
      {
        "mqtt": {
          "server": "tcp://mqtt-broker:1883",
          "topic": "bess/ekuiper/rack-01",
          "clientId": "ekuiper-rack-01",
          "dataTemplate": "{\"averageTemperature\": {{.averageTemperature}}, \"source\": \"rack-01-average-module-temperature\"}",
          "sendSingle": true
        }
      },
      { "log": {} }
    ]
  }'
echo
