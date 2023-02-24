# Example XRT application component
## Overview
The aim of this example is to demonstrate how a custom component (app_component) can be built and loaded into XRT and subsequently used alongside other components. 

This example uses the [Virtual Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/virtual-device-service-component.html) to schedule regular publishing of a store value (Int32). The data is published under `"/xrt/devices/virtual/telemetry"` topic to the bus.
A [Lua component](https://docs.iotechsys.com/edge-xrt20/transform-components/lua-transform-component.html) is attached which subscribes to this topic and transforms the data (multiplies each data value by 10) before re-publishing the new values under the topic `"/xrt/lua/transformed_data"`. There is also a custom application component attached which subscribes to the topic `"/xrt/lua/transformed_data"`, adds the two values together and increments an overall counter before re-publishing the final result back to the XRT bus under the topic `"/xrt/app_component/result"`. Lastly, an MQTT bridge component is attached which publishes the `"/xrt/app_component/result"` topic on XRT to the same topic on MQTT which can be subscribed to by any MQTT broker.


Below an illustration of the scenario described above:


![XRT application component example illustration](Application_Component.drawio.svg)

## Prerequisites

XRT dev must be installed. Verify with the command:

```bash
dpkg -l | grep iotech
```
This should show you the following packages are installed:
* iotech-iot-1.4-dev     1.4    amd64    IOT C Framework
* iotech-xrt-2.1-dev     2.1.1    amd64    XRT C RealTime Framework
If they are not please install with `sudo apt install`

Environment variables must be set as usual with the command:

```bash
cd ApplicationComponent
. ../CommonCommands/set_env_vars.sh
```
>_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

## Getting Started

### Build

First the custom component defined by app-component.c has to be built as specified by the MakeFile

This can be done as follows:

```bash
cd app-component
make
```

## Run
A configuration is provided which sets up the custom component as well as two devices generating random values. Run

```bash
xrt deployment/config
```

to start the XRT instance with the example application component.
The logs should indicate that random values are being published to the bus, transformed and the result is republished.

## Application component structure
There are a couple of function pointers to be implemented in order to support the state transitions of the application component that has been created in this example in the C language.

### alloc
Allocate component instances.

> **Note:** It is good practice to disable the publish/subscribe functionality in this function as the component may need time to initialize.

### start, stop, free
Start/stop/free the component and to update its state.

> **Note:** A component is made available to a container using the associated factory. It's up to you when and where you want to enable publish/subscribe functionality. It's good practice to enable it when the component starts and disable it upon stop.

### config
Provides the possibility to configure and access each individual field that has been set in the [`app_component.json`](../deployment/config/app_component.json) file.
  
For example:
`const char * request_topic = iot_config_string (map, "RequestTopic", false, logger);`

In the above scenario the function `iot_config_string` is used to query the content of specified field: RequestTopic.

> **Note:** The `config` function gathers the information from the json file and will be used to allocate memory for each component.

The application component config in this example has the below unique lines:
  `"RequestTopic":"/xrt/lua/transformed_data"` - topic to subscribe to
  `"ReplyTopic": "/xrt/app_component/result"` - topic to publish data to

### callback
The **callback** function is implemented in a way that it subscribes to the request topic stream, filters the values from the readings of Random-Device1 and Random-Device2, adds them together and increments an overall counter then re-publishes the result back to the bus.

> **Note:** The device data has to be filtered out from a **map**. After the data has been processed, it has to be added back to it and the **map** itself will have to be published back to the bus under the specified reply topic.

### factory
In this example, the application component is dynamically loaded, therefore the app_component.json has the **Library** and **Factory** fields defined.
