#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
"{
  \"client\": \"example\",
  \"request_id\":\"1010\",
  \"op\": \"device:add\",
  \"type\": \"xrt.request:1.0\",
  \"device\": \"ethernetip-sim\",
  \"device_info\":{
    \"protocols\":{
        \"EtherNet-IP\":{
            \"Address\": \"$ETHERNETIP_SIM_ADDRESS\",
            }
        }
    }
}"
