#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "canbus-device-01",
      "device_info":  {
        "profileName": "canbus-profile",
        "protocols":{
          "CANbus": {
            "Standard": "J1939",
            "ID": 2364539902,
            "DataSize": 8,
            "NetType": "Ethernet",
            "Port": 20001,
            "CommType": "TCP",
            "Network": "192.168.50.7"
          }
        }
      }
    },
    {
      "device": "canbus-device-02",
      "device_info":  {
        "profileName": "canbus-profile",
        "protocols":{
          "CANbus": {
            "Standard": "J1939",
            "ID": 2364539902,
            "DataSize": 8,
            "NetType": "Ethernet",
            "Port": 20001,
            "CommType": "TCP",
            "Network": "192.168.50.7"
          }
        }
      }
    },
    {
      "device": "canbus-device-03",
      "device_info":  {
        "profileName": "canbus-profile",
        "protocols":{
          "CANbus": {
            "Standard": "J1939",
            "ID": 2364539902,
            "DataSize": 8,
            "NetType": "Ethernet",
            "Port": 20001,
            "CommType": "TCP",
            "Network": "192.168.50.7"
          }
        }
      }
    }
  ]
}'
