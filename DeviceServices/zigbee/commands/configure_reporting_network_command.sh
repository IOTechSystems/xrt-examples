#!/bin/sh
docker run --rm --network host iotechsys/sparkplug-client pub -h localhost -t spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/coordinator_device -m \
'{
  "metrics":
  [
    { "name": "configure_reporting", "value":
        {
          "id": "0x000d6ffffe400162", "cluster": "msIlluminanceMeasurement", "attribute": "measuredValue",
          "minimum_report_interval":8,"maximum_report_interval":"8","reportable_change":1
        },
        "datatype": 19 }
  ]
}'