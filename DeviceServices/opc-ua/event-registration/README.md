# OPC UA Device Service - Monitor an event (alarm) Example

## Getting Started

### **Run the simulator**

_For more information about the OPC UA device simulator, see [OPC UA Simulator](https://docs.iotechsys.com/edge-xrt22/simulators/opc-ua/overview.html)._

```bash
cd DeviceServices/opc-ua
./commands/start_device_sim.sh
```

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ../../set_env_vars.sh
export OPCUA_SIM_ADDRESS=$(hostname):49947/
export OPCUA_LDS_ADDRESS=$(hostname):4840/
```

_Note the dot before the path to the script, which is required to set the environment variables in the executing shell._

An explanation for the setting of common device service environment variables can be found [here](../interactive-walkthrough/ds-getting-started-common.md#Device-service-configuration-setup).

### **Common Device Service Setup**

Follow [Device Service Example Getting Started](../interactive-walkthrough/ds-getting-started-common.md) for the common device service example setup steps.

### **Run XRT with the config folder:**

See [Setup XRT](../interactive-walkthrough/setup-xrt.md)

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

## Event Registration to monitor an Alarm

Alarm is a type of an event in OPC UA with a state condition. 

### Configure a resource for event monitoring

The below command enables monitoring an event on a resource. Please note, the configured resource should be in the profile with the `nodeAttribute` set as event.

```bash
../commands/event_register.sh
```

### Trigger the alarm

```bash
../commands/put_request_alarm.sh
```

In this example, the condition is configured to produce an event when it's severity changes.This command will change the severity of the condition and will trigger an event. The event is notified on the configured _telemetry topic_.

_For more information about event management, see [OPC UA Event Registration Component](https://docs.iotechsys.com/edge-xrt22/extension-components/opc-ua-event-registration-component.html).
