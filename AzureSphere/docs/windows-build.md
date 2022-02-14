# Building On Windows

## Build Using Visual Studio Code

See *Insert path to docs*.

## Building Using Visual Studio

* Open Visual Studio
* Create a new Project 
* Search for the "azure sphere" template, then select
  "Azure Sphere Blink" template and name the project
  "xrt-app"

* In the new created Visual Studio Project:

  * Copy the provided [config/](../config/) directory
    and [CMakeSettings.json](../CMakeSettings.json) 
    into the Visual Studio project
  * Copy and overwrite CMakeLists.txt,
    (board)/app_manifest.json,
    CMakeSettings.json and main.c with the files
    provided in the example to the Visual Studio project
  * In CMakeSettings.json, set "BOARD" to match your target board,
    e.g "mt3620-dk", "mt3620-g100", "mt3520-sk" or "mt3520-sr620"
  * In CMakeSettings.json, set "DEVICE" to match your
    target device service, e.g "modbus", "bacnet" or "virtual"

* Build the application with the "Build" menu

## Building Using Visual Studio Command Prompt

You will need to first follow the steps to build
xrt with Visual Studio from the last section, after
that you'll be able to build from the command line
within Visual Studio.

* Open Visual Studio
* Open xrt-app project
* Open Developer Command Prompt by going to
  **Tools -> Command Line -> Developer Command
  Prompt** from the Menu bar
* With the Developer Command Prompt, cd into xrt-app
  directory:
  ```bat
  cd xrt-app
  ```
* Run the build.bat batch file, with the specify
  target device service (e.g modbus, bacnet or virtual)
  and AzureSphere
  board (e.g mt3620-g100)
  ```bat
  build.bat modbus mt3620-g100
  ```  

This will build the xrt-app application image in a
sub directory called build. 
