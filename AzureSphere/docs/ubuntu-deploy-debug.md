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
