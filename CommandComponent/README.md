# Command Component Example

## Overview

This page shows you how to setup and run the command component example.

For more information about the command component please review the [Component Management](https://docs.iotechsys.com/edge-xrt20/mqtt-management/mqtt-management.html#component-management) documentation.

This example makes use of the virtual device service for demonstration purposes. For more information about this Device Service please review the [Virtual Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/virtual-device-service-component.html) documentation.

## Getting Started

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
cd CommandComponent
. ../set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

**To set them manually:**

An explanation for the setting of common device service environment variables can be found [here](../DeviceServices/interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

_Note upon running XRT a schedule is present consisting of get requests at regular intervals upon a virtual device. The purpose of this is described under Update Component within the Walkthrough section._

## Walkthrough

### List Components

This command will return a list of all component names within the XRT deployment.

```bash
./commands/list_components.sh
```

### Read Component

This command will read the state of a named component. In this case, the logger component.

```bash
./commands/read_component.sh
```

### Update Component

This command updates the configuration of a named component.

This example changes the level of the logger component to "Info" from the initial setting of "Debug". After making the change, the number of logs produced as a result of the virtual device schedule will be decreased.

```bash
./commands/update_component.sh
```

_Note: This change will not persist, and will revert to the original configuration upon restarting XRT._
