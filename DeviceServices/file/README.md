# File Device Service Example

## Overview

This page shows you how to setup and run the File example.

For more information about the Device Service please review the [File Device Service](https://docs.iotechsys.com/edge-connect33/xrt/devices/file.html)

## Getting Started

### Pre-requisites

- XRT is installed
- LD_LIBRARY_PATH has been correctly set
- XRT_LICENSE_FILE has been set to the location of the xrt license

### Set Environment Variables

We have provided a script to easily set standard environment variables. Run:

```bash
. ../../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

The example device uses an environment variable, `FILE_DIR_PATH` to set the directory path to use. Below is an example of setting the `Directory` to `example-files` using this environment variable:

```bash
export FILE_DIR_PATH=/example-files
```

### Create the Example Files

The File device service reads each resource from a file in the device's `Directory`. It does not create the directory or the files, so they must exist before reads are made, otherwise XRT logs `Could not open file` errors.

The `file-example` profile maps each resource to a file:

| Resource      | File         | Sample content |
|---------------|--------------|----------------|
| `file_string` | `string.txt` | `hello`        |
| `file_float`  | `float.txt`  | `1.5`          |
| `file_double` | `double.txt` | `2.25`         |
| `file_int8`   | `int8.txt`   | `42`           |
| `file_int16`  | `int16.txt`  | `42`           |
| `file_int32`  | `int32.txt`  | `42`           |
| `file_int64`  | `int64.txt`  | `42`           |
| `file_uint8`  | `uint8.txt`  | `42`           |
| `file_uint16` | `uint16.txt` | `42`           |
| `file_uint32` | `uint32.txt` | `42`           |
| `file_uint64` | `uint64.txt` | `42`           |

Each file contains the value as plain text. To create them in `${FILE_DIR_PATH}`:

```bash
mkdir -p ${FILE_DIR_PATH}
cd ${FILE_DIR_PATH}
echo -n "hello" > string.txt
echo -n "1.5" > float.txt
echo -n "2.25" > double.txt
for t in int8 int16 int32 int64 uint8 uint16 uint32 uint64; do echo -n "42" > $t.txt; done
cd -
```

> **Note** Make sure the user running XRT has read and write permissions on the directory and files.

### Batch Operations

The batch commands are described in the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md). For this example, `commands/add_batch_devices.sh` adds three devices, `file-example-01`, `file-example-02` and `file-example-03`, using the `file-example` profile. All three take their `Directory` from `FILE_DIR_PATH`, so they share the files listed above and no extra files are needed.

`FILE_DIR_PATH` is expanded by the shell when the command is sent. It must be exported in the shell that runs the command scripts, not only in the shell that runs XRT. If it is not set, the device is added with an empty `Directory`.

To use a separate directory for each device, edit the `Directory` value of each device in `commands/add_batch_devices.sh` and create the files listed above in each directory.

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
