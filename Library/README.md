# Using XRT as a Library

This folder contains examples of how XRT can be used as a library, allowing you to start XRT, send requests, receive replies on the bus, and cleanly stop XRT. The examples demonstrate the following steps:

1. Start XRT
2. Create a Pub/Sub Connection
3. Send a request to get a list of all devices
4. Receive a reply with the list of devices
5. Iterate through the devices, retrieve their readings, and output the values
6. Terminate the Pub/Sub Connection
7. Stop XRT

This approach allows you to integrate XRT into your existing business logic.

## Prerequisites

Before running the examples, ensure that you have the following:

- XRT library and headers installed (typically in `/opt/iotech/xrt/2.2`)
- IOT library and headers installed (typically in `/opt/iotech/iot/1.5`)
- C or C++ compiler (gcc or g++)

installation instruction for XRT and it's prerequisite IOT Utils can be found [here](https://docs.iotechsys.com/edge-xrt22/installation/installation.html)

## Compiling the Programs

### C Example

To compile the C program, use the following command:

```bash
gcc ./demo.c -I/opt/iotech/xrt/2.2/include -L/opt/iotech/xrt/2.2/lib -lxrt -I/opt/iotech/iot/1.5/include -L/opt/iotech/iot/1.5/lib -liot -o demo
```

### C++ Example

To compile the C++ program, use the following command:

```bash
g++ ./demo.cpp -I/opt/iotech/xrt/2.2/include -L/opt/iotech/xrt/2.2/lib -lxrt -I/opt/iotech/iot/1.5/include -L/opt/iotech/iot/1.5/lib -liot -o demo
```

## Setting Up the Environment

Before running the compiled program, you need to set up the environment by running the this command:

```bash
. ../set_env_vars.sh
```

## Running the Program

After setting up the environment, you can run the compiled program using the following command:

```bash
./demo
```

The program will start XRT, create a Pub/Sub connection, send a request to get the list of devices, receive the reply, iterate through the devices, retrieve their readings, output the values, terminate the Pub/Sub connection, and finally stop XRT. The Pub/Sub is all done over the internal bus rather then MQTT leading to lower latency and use the same structure as xrt MQTT request just as a IOT_DATA_T Map. The MQTT docs for reference can be found [here](https://docs.iotechsys.com/edge-xrt22/mqtt-management/mqtt-management.html).