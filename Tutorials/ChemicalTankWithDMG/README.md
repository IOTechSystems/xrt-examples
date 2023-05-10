# Chemical Tank Demo Setup
* Add a nodered-data directory for mounting
* Add license.json under scripts/

## Initialise Xrt
* Navigate to scripts directory
* `./init_dmg.sh`
  * You should be able to see these devices in the manager at http://localhost:9092

## Connecting nodered to opcua server
* Import the flows.json into nodered dashboard
* Update the IP address of opc-ua server if xrt-demo does not resolve correctly

# Current run command 
docker compose up xrt mqtt-broker modbus-sim nodered influxdb grafana
