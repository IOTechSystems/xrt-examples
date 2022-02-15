# Building, Deploying and Debugging on Ubuntu

* Set the `BOARD` variable, in-order to build for your targeted
  Azure Sphere Module, for modbus example `BOARD` will be set to
  `BOARD=mt3620-g100`
* Set the `DEVICE` variable to the intended Device Service,
  for  modbus example `DEVICE` should be set to `DEVICE=modbus`

Issue the command to build XRT:

```bash
make build \
DEVICE=<modbus, bacnet or virtual> \
BOARD=<mt3620-g100, mt3620-dk, mt3620-sk or mt3620-sr620>
```
# Deploy And Debug With Ubuntu

Issue the following command to deploy the application and
initiate a Telnet session:

```bash
make monitor
```

In another shell issue the command:

```bash
/opt/azurespheresdk/Sysroots/8/tools/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-musleabi/arm-poky-linux-musleabi-gdb xrt-app.out
```

In gdb issue the commands:

```
(gdb) set sysroot /opt/azurespheresdk/Sysroots/8
(gdb) target remote 192.168.35.2:2345
(gdb) continue
```

Observe the debug output in the terminal where the make
command was issued. The simulated Modbus device inputs
are read at an interval specified in the Modbus device
service configuration.
