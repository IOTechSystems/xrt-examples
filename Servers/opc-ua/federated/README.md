# Sunspec on OPC-UA

This example demonstrates how to operate the OPC-UA server using a [Sunspec model](https://sunspec.org/wp-content/uploads/2015/06/SunSpec-Information-Models-12041.pdf) that has been converted into an OPC-UA nodeset. Specifically, it utilizes a modified version of Sunspec's [Model805](https://github.com/sunspec/models/blob/master/json/model_805.json) to create an instance of a Lithium-ion
Battery Module Model with three cells. Additionally, this implementation maps resources from a Modbus-tcp simulator to the OPC-UA interface.

For more information about the OPC-UA Server and Node Modelling please review the [OPC-UA Server](https://docs.iotechsys.com/edge-xrt30/server-components/opc-ua-server-component.html) documentation.

For more information about the Modbus Device Service please review the [Modbus Device Service](https://docs.iotechsys.com/edge-xrt30/device-service-components/Modbus-device-service-component.html) documentation.

### Prerequisites
- Docker must be installed on your machine. (can be checked using `docker -v`)
- XRT must be installed, along with a copy of this repository. 
- Python 3 must also be installed. (can be checked using `python3 -v`)
    
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

1. **Navigate to the Example Directory**: Ensure that you have a terminal open and are in the "modbus-tcp" directory containing the "sim-files" folder.  The  "sim-files" directory will be mapped to a corresponding directory inside the Docker container, allowing the container to access its contents.
    ```shell
    cd ./Servers/opc-ua/federated/opc-ua
    ```
2. **Set Enviroment Variables**:
    ```shell
    . ./../set_env_vars.sh
    ```
    An explanation for the manual setting of common device service environment variables can be found [here](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).


3. **Run XRT with config folder**
   See [Setup XRT](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/setup-xrt.md)
   ```shell
   xrt ./deployment/config
	```

4. **Check OPC-UA Browser**: Now if XRT is set up correctly you should see no error on the console output and be able to connect to the opc-ua server using the opc-browser and your machines IP.

    You should be able to see the nodeset model loaded in however no values populated as we have yet to connect our simulated device.

## Mod-Bus Simulator Setup  
This section covers the setup of a Mod-Bus simulator using Docker. 
### Steps 
1. **Navigate to the Example Directory**: Ensure that you have a terminal open and are in the "modbus-tcp" directory containing the "sim-files" folder.  The  "sim-files" directory will be mapped to a corresponding directory inside the Docker container, allowing the container to access its contents.
```shell
cd ./Servers/opc-ua/federated/modbus-tcp
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

## Mod-Bus Device Service  
Now we have the simulated modbus battery we can move on to connecting the battery to a XRT device service which will push the reading from it to the OPC-UA server
### Steps

1. **Navigate to the Example Directory**: Ensure that you have a terminal open and are in the "modbus-tcp" directory containing the "sim-files" folder.  The  "sim-files" directory will be mapped to a corresponding directory inside the Docker container, allowing the container to access its contents.
    ```shell
    cd ./Servers/opc-ua/federated/modbus-tcp
    ```
2. **Set Enviroment Variables**:
    ```shell
    . ./../set_env_vars.sh
    ```
    An explanation for the manual setting of common device service environment variables can be found [here](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).


3. **Run XRT with config folder**
   See [Setup XRT](https://github.com/IOTechSystems/xrt-examples/blob/v3.0-branch/DeviceServices/interactive-walkthrough/setup-xrt.md)
   ```shell
   xrt ./deployment/config
	```

4. **Check your OPC-UA Browser**
