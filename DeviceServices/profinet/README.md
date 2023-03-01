# PROFINET Device Service Example

## Overview

This page shows you how to setup and run XRT with specific PROFINET hardware. You will need to adapt the example for your own configuration.

For more information about the Device Service please review the [PROFINET Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/profinet-device-service-component.html) documentation.

## Getting Started

### Hardware configuration

The scenario implemented in this example features the following hardware:

- Hilscher netHAT for Raspberry Pi

### Set Environment Variables

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/profinet
. ../../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service enviroment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### Common Device Service Setup

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### Run XRT with the config folder:

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
