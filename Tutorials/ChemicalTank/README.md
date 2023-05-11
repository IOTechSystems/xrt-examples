# Chemical Tank Demo Setup

## General Setup
* Add a `nodered-data` directory for mounting
* Add a `grafana-data` directory for mounting
* Add `license.json` under `scripts` directory

## First Time Running
When running the demo for the first time there is some additional setup that once done will not need done again.

### Nodered Setup
* Install the `node-red-contrib-opcua` module via the dashboard interface:
  - Menu -> Manage Palette -> Install
* Import the `flows.json` file found in the `scripts` directory into nodered dashboard
* Select `Deploy` from the nodered dashboard

### Grafana Setup
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

The demo can also be run using ModbusPal as the simulator or an alternative Modbus simulator.

## Run with Pre-Configured Devices
To run with pre-configured devices, enter the `ChemicalTank` directory and run the following command:

```shell
docker compose up
```



This will start all services in the `docker-compose.yml` file. XRT will start using the pre-configured devices for Modbus and S7 services.

## Run with the Device Management Tool


