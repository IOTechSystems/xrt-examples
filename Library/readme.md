Certainly! Here's the tutorial in a Markdown format:

```markdown
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
- IoT library and headers installed (typically in `/opt/iotech/iot/1.5`)
- C or C++ compiler (gcc or g++)

## Compiling the Programs

### C Example

To compile the C program, use the following command:

```bash
gcc ./demo.c -I/opt/iotech/xrt/2.2/include -L/opt/iotech/xrt/2.2/lib -lxrt -I/opt/iotech/iot/1.5/include -L/opt/iotech/iot/1.5/lib -liot -o demo
```

### C++ Example

To compile the C++ program, use the following command:

```bash
g++ ./demo.cpp -I/opt/iotech/xrt/2.2/include -L/opt/iotech/xrt/2.2/lib -lxrt -I/opt/iotech/iot/1.5/include -L/opt/iotech/iot/1.5/lib -liot -o demo -std=c++11 -pthread
```

## Setting Up the Environment

Before running the compiled program, you need to set up the environment by running the `setenv.sh` script located in the same folder:

```bash
./setenv.sh
```

This script sets the necessary environment variables, telling the program where the configuration for the XRT instance it will set up is located.

## Running the Program

After setting up the environment, you can run the compiled program using the following command:

```bash
./demo
```

The program will start XRT, create a Pub/Sub connection, send a request to get the list of devices, receive the reply, iterate through the devices, retrieve their readings, output the values, terminate the Pub/Sub connection, and finally stop XRT.

You can view the program's progress and output in the log file.

## Additional Tips

- Make sure you have the necessary permissions to access the XRT and IoT library directories.
- If you encounter any issues, double-check the paths to the include and library directories in the compilation commands.
- Feel free to modify the example programs to fit your specific use case and requirements.
- Refer to the XRT and IoT library documentation for more detailed information on the available functions and APIs.

With these examples and steps, you should be able to successfully integrate XRT into your existing business logic as a library.
```

This Markdown file provides the same content as the previous response but with proper formatting and structure suitable for a Markdown document.
