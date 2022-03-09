#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
  "{
    'client': 'example',
    'request_id':'1010',
    'op': 'device:add',
    'device': 'modbus-sim',
    'device_info':  {
      'profileName': 'modbus-sim-profile',
      'protocols': {
       'modbus-rtu': {
           'Address': '/tmp/virtualport',
           'BaudRate': 19200,
           'DataBits': 8,
           'Parity': 'N',
           'StopBits': 1,
           'UnitID': 1
        }
      }
    }
  }"

