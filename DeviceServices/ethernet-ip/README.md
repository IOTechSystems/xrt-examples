# EtherNet/IP Device Service Examples

## Overview
This page shows you how to setup and run the EtherNet/IP Device Service Example.

For more information about the Device Service please review the [EtherNet/IP Device Service](https://www.link.to.ethernetip.docs) documentation.

## Getting Started

### Run the simulator

*for more information about the EtherNet/IP device simulator, see [EtherNet/IP Simulator](https://www.link.to.sim).*

```
./commands/start_device_sim.sh
```

### Set Environment Variables

We have provided a script to easily set these environment variables. Run:

```
. ./commands/set_env_vars.sh
```
*Note the dot before the path to the script, which is required to set the environment variables in the executing shell.*

#### To set them manually:

`ETHERNETIP_SIM_ADDRESS` - The address of the EtherNet/IP Simulator
 ```
 export ETHERNETIP_SIM_ADDRESS=<IP-Address>
 ```

 An explanation for the setting of common device service enviroment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md/#Device-service-configuration-setup).

### Common Device Service Setup
Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### Run XRT with the config folder:

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```
cd ethernet-ip
xrt config
```

## Walkthrough

### Basic Operations
For basic device service operations see the [Basic Operations Walkthrough](../interactive-walkthrough/basic-operations.md) guide.
