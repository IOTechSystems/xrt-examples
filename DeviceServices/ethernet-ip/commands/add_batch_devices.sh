#!/bin/sh

# Each device connects to its own simulator, started by start_device_sim.sh
sim_address ()
{
  docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1
}

SIM_01_ADDRESS=$(sim_address ethernetip-sim-01)
SIM_02_ADDRESS=$(sim_address ethernetip-sim-02)
SIM_03_ADDRESS=$(sim_address ethernetip-sim-03)

if [ -z "$SIM_01_ADDRESS" ] || [ -z "$SIM_02_ADDRESS" ] || [ -z "$SIM_03_ADDRESS" ]
then
  echo "Simulators ethernetip-sim-01..03 are not running, run start_device_sim.sh first"
  exit 1
fi

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "ethernetip-sim-device-01",
      "device_info": {
        "profileName": "ethernetip-sim-profile",
        "protocols":{
          "EtherNet-IP":{
            "Address": "'"$SIM_01_ADDRESS"'",
            "O2T":{
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            },
            "T2O": {
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            }
          }
        }
      }
    },
    {
      "device": "ethernetip-sim-device-02",
      "device_info": {
        "profileName": "ethernetip-sim-profile",
        "protocols":{
          "EtherNet-IP":{
            "Address": "'"$SIM_02_ADDRESS"'",
            "O2T":{
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            },
            "T2O": {
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            }
          }
        }
      }
    },
    {
      "device": "ethernetip-sim-device-03",
      "device_info": {
        "profileName": "ethernetip-sim-profile",
        "protocols":{
          "EtherNet-IP":{
            "Address": "'"$SIM_03_ADDRESS"'",
            "O2T":{
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            },
            "T2O": {
              "ConnectionType": "p2p",
              "RPI": 10,
              "Priority": "low",
              "Ownership": "exclusive"
            }
          }
        }
      }
    }
  ]
}'
