#!/bin/sh

mosquitto_pub -t xrt/device/odbc/request -m \
'{
    "query" : "select name from sysdatabases"
}'