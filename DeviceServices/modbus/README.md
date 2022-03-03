# XRT Config Examples

## Overview

This page shows you how to setup and run the Modbus-TCP device service example.

For more information about the Device Service please review the [Modbus Device Service](https://www.link.to.modbus.device.service.docs) documentation.

## Getting Started

### **Run the simulator**

```bash
./commands/start_device_sim.sh
```

If the RTU version of the simulator is required, add 'rtu' to the end of the command, as shown below: 

```bash
./commands/start_device_sim.sh rtu
```

This will run either a TCP or RTU simulator, depending on the argument provided. This argument should also be used when stopping the simulator if it uses RTU: 

```bash
./commands/stop_device_sim.sh rtu
```

If not using RTU mode, no argument is required for the scripts to run in TCP mode. 

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ./commands/set_env_vars.sh
```

*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

If you want to run the RTU example, as opposed to the default TCP example provided, run the following:

```bash
. ./commands/set_env_vars.sh rtu
```

With no argument provided, or any value other than `rtu`, TCP will be used. The remaining commands will be the same between TCP and RTU, as the flag for using
RTU options is set as one of the environment variables inside the script.

An explanation for the setting of common device service environment variables can be
found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd modbus
xrt deployment/config
```

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

