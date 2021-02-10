# Deploying and Debugging from Visual Studio

The easiset way to debug the application is using [Visual Studio](https://docs.microsoft.com/en-us/azure-sphere/install/qs-blink-application?tabs=linux%2Ccliv1&pivots=visual-studio). This supports loading an image onto the target device, connecting it to the debugger and reporting diagnostic logging.

## Deploying and Debugging from Visual Studio Command Prompt

The deployd.bat batch script will deploy the built application onto the target device, put the application into debug mode and attach the gdb debugger:

`deployd.bat`

To monitor the log output from the application, from another command window, connect using telnet:

`telnet 192.168.35.2 2342`

The application can then be started via gdb:

`(gdb) set sysroot "C:\Program Files (x86)\Microsoft Azure Sphere SDK\Sysroots\7"`

`(gdb) target remote 192.168.35.2:2345`

`(gdb) continue`

