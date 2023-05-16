# Chemical Tank Demo Setup

## General Setup
* Add a `nodered-data` directory for mounting
* Add a `grafana-data` directory for mounting
* Add `license.json` under `scripts` directory

## First Time Running
When running the demo for the first time there is some additional setup that once done will not need done again.

### Nodered Setup
* Go to the node red dashboard at http://localhost:1880 
* Install the `node-red-contrib-opcua` module via the dashboard interface:
  - Menu -> Manage Palette -> Install
* Import the `flows.json` file found in the `scripts` directory into nodered dashboard
* Select `Deploy` from the nodered dashboard

### Grafana Setup
* Go to the Grafana Dashboard at http://localhost:3000
* Login using the Following:
  - `User` : `admin`
  - `Password` : `admin-password`
* Select `Configuration` -> `Data Sources`
* Add the InfluxDB Data Source with the following properties:

| Parameter | Value |
| --- | ----------- |
| Name | InfluxDB |
| Query Language | Flux |
| URL | http://xrt-influxdb:8086 |
| Basic Auth | On |
| User | admin |
| Password | admin-password |
| Organization | IOTech |
| Token | abcde== |
| Default Bucket | demo_bucket |

* Select `+` -> `Import`
* Select to either upload the `Grafana.json` file or copy and paste the contents into the input box


# Running the Demo
There are two methods of running the demo:
* Run with pre-configured devices
* Run with the Device Management Tool

The demo can be run using ModbusPal as the simulator or an alternative Modbus simulator. If ModbusPal is used the following must be done before following either method of running the demo.

* Start ModbusPal
```shell 
java -jar ModbusPal.jar
```
* Import the `demo_config.xmpp` file into ModbusPal.
* Update the `MODBUS_SIM_PORT` and `MODBUS_SIM_ADDRESS` in the `env-file.env` to the following:
  - `MODBUS_SIM_ADDRESS` : `"172.17.0.1"`
  - `MODBUS_SIM_PORT` : `1502`

## Run with Pre-Configured Devices
To run with pre-configured devices, enter the `ChemicalTank` directory and run the following command:

```shell
docker compose up
```
This will start all services in the `docker-compose.yml` file. XRT will start using the pre-configured devices for Modbus and S7 services.

## Run with the Device Management Tool

### Remove Pre-Configured Devices
Clear the `devices.json` and `profiles.json` files of any listed devices and profiles.

### Initialise Device Manager
Please ensure that the dmg-manager command is installed following [these instructions](https://github.com/IOTechSystems/device-management-gui)

### Run Commands 
* `docker compose up`
* Start the manager with `dmg-manager up --custom-broker <ip-address-of-broker>`

### Initialise Xrt
* Navigate to `Tutorials/ChemicalTank/scripts` directory
* `./init_dmg.sh`
* You will be able to see these devices in the manager at http://localhost:9092
* Login to the device manager using the following:
  - `user` : `iotech`
  - `password` : `dmgAdmin123@`

## Using the OPC-UA Browser Tool
The OPC-UA Browser tool is included in the `docker-compose.yaml` file as `browser`. This will be started when running `docker compose up`.

### Connect to OPC-UA Server
* Go to http://localhost:8080
* In the prompt box enter `opc.tcp://xrt-demo:4840`
* In the pop-up window leave the defaults as `Security Mode` is `None` and `User Authenitcation` as `Anonymous`
* Click Save and Connect

The Objects and Types are displayed on the left for navigation.

