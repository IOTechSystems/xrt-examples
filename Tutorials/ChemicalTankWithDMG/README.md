# Chemical Tank Demo Setup
* Add a nodered-data directory for mounting
* Add license.json under scripts/

## Initialise Device Manager
* Please ensure that the dmg-manager command is installed following [these instructions](https://github.com/IOTechSystems/device-management-gui)


## Connecting nodered to opcua server
* Import the flows.json into nodered dashboard
* Update the IP address of opc-ua server if xrt-demo does not resolve correctly

### Current run command 
* `docker compose up xrt mqtt-broker modbus-sim nodered influxdb grafana`
* Start the manager with `dmg-manager up --custom-broker <ip-address-of-broker>`

### Initialise Xrt
* Navigate to `Tutorials/ChemicalTankWithDMG/scripts` directory
* `./init_dmg.sh`
* You should be able to see these devices in the manager at http://localhost:9092
