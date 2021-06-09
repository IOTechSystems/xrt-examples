# Simple XRT Component Example

This example uses the Virtual Device Service to generate some random data (Int8). The data is published under "virtual_device_service/data" topic to the bus.
A Lua component is attached which subscribes to both data streams and transforms the data (multiplies each data value by 10) before re-publishing the new values under the topic "virtual_device_service/transformed_data". There is also a C component attached which subscribes to the topic "virtual_device_service/transformed_data" and then adds the two random values together before re-publishing the final result back to the XRT bus under "device/result" topic. Lastly, an MQTT bridge component - which subscribes to the final result published on the bus by the C component - re-publishes it to a Mosquitto topic so that the data can be accessed by any client subscribed to the MQTT topic "device/result".

Below an illustration of the scenario described above:

![Simple XRT Component Example illustration](Simple_XRT_Component_Example.jpg)

## Prerequisites
    XRT must be installed and environment variables must be set via env.sh
    * iotech-iot-dev     1.2.1    amd64    IOT C Framework
    * iotech-thrift-dev  1.0.1    amd64    Embedded Thrift C Version
    * iotech-xrt-dev     1.1.1    amd64    XRT C RealTime Framework

## Build
Open a terminal window in the directory containing the example. Run

. ./envs.sh

to set up the environment, then

make

to build the example component.

## Run
A configuration is provided which sets up two devices generating random values. Run

xrt config

to start the XRT instance with the example component. The logs should indicate a value being published every two/four seconds.


## C component description
