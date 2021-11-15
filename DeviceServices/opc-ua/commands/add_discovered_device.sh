mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id":"1060",
  "op": "device:add",
  "device": "opc-ua-sim",
  "device_info":  {
    "protocols":{
      "OPC-UA":{
        "Address": "${OPCUA_SIM_ADDRESS}",
        "Security": "None"
      }
    }
  }
}'