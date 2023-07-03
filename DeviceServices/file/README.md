# File Device Service Example

## Overview

This page shows you how to setup and run the File example.

For more information about the Device Service please review the [File Device Service](https://docs.iotechsys.com/edge-xrt30/device-service-components/file-device-service-component.html)

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
