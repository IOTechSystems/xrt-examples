# Simple XRT Component Example

This example uses the **Virtual Device Service** to generate some random data (Int8). The data is published under `"virtual_device_service/data"` topic to the bus.
A Lua component is attached which subscribes to both data streams and transforms the data (multiplies each data value by 10) before re-publishing the new values under the topic `"virtual_device_service/transformed_data"`. There is also a custom C component attached which subscribes to the topic `"virtual_device_service/transformed_data"`, adds the two random values together before re-publishing the final result back to the XRT bus under the topic `"virtual_device_service/result"`. Lastly, an MQTT exporter component is attached which re-publishes the result on `"virtual_device_service/final_result"` (using Mosquitto) so that the data can be accessed by any client subscribed to that MQTT topic on the broker.

Below an illustration of the scenario described above:

![Simple XRT Component Example illustration](Simple_XRT_Component_Example.jpg)

## Prerequisites
  XRT dev must be installed and environment variables must be set via env.sh
  * iotech-iot-dev     1.2.1    amd64    IOT C Framework
  * iotech-thrift-dev  1.0.1    amd64    Embedded Thrift C Version
  * iotech-xrt-dev     1.1.1    amd64    XRT C RealTime Framework

## Build
Open a terminal window in the directory containing the example. Run

`. ./envs.sh`

to set up the environment, then

`make`

to build the example component.

## Run
A configuration is provided which sets up two devices generating random values. Run

`xrt config`

to start the XRT instance with the example C component.
The logs should indicate that values are being published every two/four seconds.

## C component structure
There are a couple of function pointers to be implemented in order to support the state transitions of the simple C component that has been created in this example.

### alloc
Allocate component instances

> **Note:** It is good practice to disable the publish/subscribe functionality in this function as the component may need time to initialize.

### start, stop, free
These functions are used to start/stop/free the component and to update its state.
> **Note:** A component is made available to a container using the associated factory. It's up to you when and where you want to enable publish/subscribe functionality. It's good practice to enable it when the component starts and disable it upon stop.

### config
This function provides the possibility to configure and access each individual field that has been set in the [`mycomponent.json`](https://github.com/IOTechSystems/xrt-examples/blob/XRT-633-branch/SimpleXRTComponentExample/config/mycomponent.json) file.
  
For example:
`const char * request_topic = iot_config_string (map, "RequestTopic", false, logger);`

In the above scenario the function `iot_config_string` is used to query the content of specified field: RequestTopic.

> **Note:** The `config` function gathers the information from the json file and will be used to allocate memory for each component.

The custom component json in this example has the below unique lines:
  `"RequestTopic":"virtual_device_service/transformed_data"` - topic to subscribe to
  `"ReplyTopic": "virtual_device_service/result"` - topic to publish data to

### callback
The **callback** function in this example is implemented in a way that it subscribes to the request topic stream, filters the values from the readings of Random-Device1 and Random-Device2, adds them together and re-publishes the result back to the bus.

> **Note:** The device data has to be filtered out from a **map**. After the data has been processed, it has to be added back to the map and the map itself will have be published back to the bus under the specified reply topic.

### factory
A component is made available to a container using the associated factory. In this example, the component is dynamically loaded, therefore the mycomponent.json has the **Library** and **Factory** fields defined.