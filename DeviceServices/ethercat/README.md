# EtherCAT Device Service Example

## Overview

This page shows you how to setup and run XRT with specific EtherCAT hardware. You will need to adapt the example for your own configuration.

For more information about the Device Service please review the [EtherCAT Device Service](https://docs.iotechsys.com/edge-xrt20/device-service-components/ethercat-device-service-component.html) documentation.

## Getting Started

### Hardware configuration

The scenario implemented in this example features the following hardware:

- Beckhoff EK1100 EtherCAT Coupler
- Beckhoff EL7037 EtherCAT Stepper Motor Terminal (mounted in the EK1100)
- Infineon XMC 48000 Relax EtherCAT kit

The Beckhoff equipment is connected first in the EtherCAT chain.

### Set Environment Variables

We have provided a script to easily set these environment variables. Run:

```bash
cd DeviceServices/ethercat
. ../../CommonCommands/set_env_vars.sh
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service enviroment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### Common Device Service Setup

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### Run XRT with the config folder:

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
cd DeviceServices/ethercat
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Walkthrough

### Basic Operations

For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.

### LED control for XMC4800

Let's switch some of the XMC4800's LEDs on. This command issues a device put request with multiple resources.

```bash
./commands/put_request_leds_on.sh
```

And switch all of the controllable LEDs off:

```bash
./commands/put_request_leds_off.sh
```

### Motor control for EL7037

The provided configuration initializes the EL7037 in "Velocity Direct" mode. There is an enabling flag which must be set before driving the motor:

```bash
./commands/put_request_motor_enable.sh
```

Having enabled motor control we can start and stop the motor by writing the "Velocity - STM Velocity - PDO" resource:

```bash
./commands/put_request_motor_start.sh
./commands/put_request_motor_stop.sh
```
