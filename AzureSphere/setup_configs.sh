#!/bin/bash

echo ====================================================================
echo "IoTech Ltd, 2022"
echo
echo "Azure Sphere Initial Set-Up Scirpt"
echo
echo "To learn more visit:"
echo "https://github.com/IOTechSystems/xrt-examples"
echo =====================================================================
echo
read -rep $'Enter host network interface: \n networkIface=' networkIface
echo 
read -rep $'Enter Tenent UUID - can be found using \n \"azsphere tenant list\" \n tenantUUID=' tenantUUID
echo 
read -rep $'Enter iothub Host Name - can be found using \n \"az iot hub show --name <IOT_Hub_name> | grep hostName\" \n hostName=' hostName
echo 
read -rep $'Enter scopeID - can be found using \n \"az iot dps show --name <DPS_NAME> | grep idScope \" \n scopeID=' scopeID


deviceID=$(azsphere device list-attached | grep "Device ID:" | sed 's/^.*: //')
HostIP=$(/sbin/ip -o -4 addr list $networkIface | awk '{print $4}' | cut -d/ -f1)

echo
echo "Device ID set to $deviceID"
echo "Tenent UUID set to: $tenantUUID"
echo "Host name set to: $hostName"
echo "Host network interface set to: $networkIface"
echo "Host IP address set to: $HostIP"
echo
echo

find . -type f -name "*.json" -exec sed -i "s/<DEVICE-ID>/$deviceID/g" {} \;
find . -type f -name "*.json" -exec sed -i "s/<SCOPE-ID>/$scopeID/g" {} \;
find . -type f -name "*.json" -exec sed -i "s/<iot_hub_hostname>/$hostName/g" {} \;
find . -type f -name "*.json" -exec sed -i "s/<host-ip>/$HostIP/g" {} \;
find . -type f -name "*.json" -exec sed -i "s/<tenant-uuid-identifier>/$tenantUUID/g" {} \;
