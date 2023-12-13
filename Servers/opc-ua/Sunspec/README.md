# Sunspec on OPC-UA

This example demonstrates how to operate the OPC-UA server using a [Sunspec model](https://sunspec.org/wp-content/uploads/2015/06/SunSpec-Information-Models-12041.pdf) that has been converted into an OPC-UA nodeset. Specifically, it utilizes a modified version of Sunspec's [Model805](https://github.com/sunspec/models/blob/master/json/model_805.json) to create an instance of a Lithium-ion
Battery Module Model with three cells. Additionally, this implementation maps resources from a Modbus tcp simulator to the OPC-UA interface.

For more information about the OPC-UA Server and Node Modelling please review the [OPC-UA Server](https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html) documentation.

For more information about the Modbus Device Service please review the [Modbus Device Service](https://docs.iotechsys.com/edge-xrt22/device-service-components/Modbus-device-service-component.html) documentation.

### Prerequisites
- Docker must be installed on your machine. (can be checked using `docker -v`)
- XRT must be installed, along with a copy of this repository.

## Mod-Bus Simulator Setup  
This section covers the setup of a Mod-Bus simulator using Docker.  
### Steps 
1. **Navigate to the Example Directory**: Ensure that you have a terminal open and are in the "Sunspec" directory containing the "sim-files" folder.  The  "sim-files" directory will be mapped to a corresponding directory inside the Docker container, allowing the container to access its contents.
```shell
cd ./Servers/opc-ua/Sunspec/
```

2. **Pull Docker Image**:    
```shell
docker pull iotechsys/pymodbus-sim:1.0
```
3. **Run the Container**: Run the following command to sets up the Modbus simulator:
```shell
docker run --name my_pymodbus_sim -v $(pwd)/sim_files:/sim_files --rm --network host iotechsys/pymodbus-sim:1.0 --profile /sim_files/modbus-profile.json --script /sim_files/MyScript --port 1502 --delay 1
```
4. **Verify Run**:
    - Execute the command `docker ps` in your terminal.
    - Confirm that an image named 'iotechsys/pymodbus-sim' is listed in the output.
    
## OPC-UA Browser Setup
This section outlines the setup process for the IOTech OPC-UA browser. If you opt to use a different OPC-UA browser, please refer to the corresponding instructions specific to that browser.
### Steps
1. **Pull Docker Image**:
```shell
docker pull iotechsys/opc-ua-browser:1.1.dev
```

    
2. **Run the Browser**: Use the following command to run the OPC-UA browser:
    
```shell
docker run -d --name opc-ua-browser -p 8080:8080 iotechsys/opc-ua-browser:1.1.dev
```
3. **Verify Run**:
    - Execute the command `docker ps` in your terminal.
    - Confirm that an image named 'iotechsys/opc-ua-browser' is listed in the output.
4. **Access the Browser**: Connect to the OPC-UA browser at [http://0.0.0.0:8080/](http://0.0.0.0:8080/) in your web browser of choice.

## XRT OPC-UA Server
Now we have the browser and simulator working we can move on to setting up XRT. 
### Steps
1. **Set Enviroment Variables**:
```shell
. ../../../set_env_vars.sh
export MODBUS_SIM_ADDRESS=0.0.0.0
export MODBUS_SIM_PORT=1502
export SPARKPLUG_NODE=xrt
export SPARKPLUG_GROUP=iotech
export SPARKPLUG_PROTO=spb
export XRT_MODELS_DIR=$PWD/deployment/models
export XRT_NODESET_DIR=$PWD/deployment/nodesets
```
The dot before the path to the script, which is required to set the environment variables in the executing shell.

An explanation for the manual setting of common device service environment variables can be found [here](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).


2. **Run XRT with config folder**
   See [Setup XRT](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/setup-xrt.md)
   ```shell
   xrt deployment/config
	```

3. Now if XRT is set up correctly you should be able to connect to the server through the browser and see the nodeset model loaded in. Furthermore you should be able to see the temperature values of the three cell increasing showing values being read and written

