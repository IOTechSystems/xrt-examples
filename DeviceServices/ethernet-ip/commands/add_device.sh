#!/bin/sh

mosquitto_pub -t xrt/device/ethernet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "ethernetip-sim",
  "device_info":{
    "profile": "ethernetip-sim-profile",
    "protocols":{
        "IP":{
            "Address": "${ETHERNETIP_SIM_ADDRESS}"
            },
        "O2T":{
            "ConnectionType": "p2p",
            "RPI": "10",
            "Priority": "low",
            "Ownership": "exclusive"
            },
        "T2O": {
            "ConnectionType": "p2p",
            "RPI": "10",
            "Priority": "low",
            "Ownership": "exclusive"
            }
        }
    }
}'
