# Building, Deploying and Debugging on Ubuntu

XRT for AzureSphere can be built and run on Visual Studio Code, to see how you can build on vscode see [Building on Visual Studio Code](./vscode-build.md).


You can also use the Linux command line to configure, build and debug
XRT Azure Sphere applications.

* Set the `BOARD` variable, in-order to build for your targeted
  Azure Sphere Module, for modbus example `BOARD` will be set to
  `BOARD=mt3620-g100`
* Set the `DEVICE` variable to the intended Device Service,
  for  modbus example `DEVICE` should be set to `DEVICE=bacnet`

Issue the command to build XRT:

```bash
make build \
DEVICE=<bacnet or ethernet-ip> \
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
/opt/azurespheresdk/Sysroots/12/tools/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-musleabi/arm-poky-linux-musleabi-gdb xrt-app.out
```

In gdb issue the commands:

```
(gdb) set sysroot /opt/azurespheresdk/Sysroots/12
(gdb) target remote 192.168.35.2:2345
(gdb) continue
```

Observe the debug output in the terminal where the make
command was issued.
