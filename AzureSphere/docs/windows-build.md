# Building, Deploying and Debugging on Windows

You can use Visual Studio Code to configure, build and debug AzureSphere XRT applications.

## Install and Configure Visual Studio Code

To build XRT applications using Visual Studio on Windows, complete the following steps:

1. Install Visual Studio Code, if not already installed. See <https://code.visualstudio.com/>.

2. Install Build Tools.

    * Install Cmake. See <https://cmake.org/download/>.

    * Download Ninja. See <https://github.com/ninja-build/ninja/releases>.

    * Extract the Ninja executable into C:\\Program Files\\CMake\\bin

3. Install the following extensions:

    * Azure Sphere
    * CMake Extensions
   
4. Install ncat (part of Nmap) (optional). See <https://nmap.org/download>.
   
5. Navigate to the Azure Sphere example in the VS Code explorer.

    Open .vscode/settings.json
    
    * Ensure the value of the "DEVICE" configuration is set to the required device service
    e.g. "bacnet" or "ethernet-ip".
    * Ensure the value of the "BOARD" configuration is set to the required board type.
    The options are "mt3620-dk", "mt3620-g100", "mt3620-sk" or "mt3620-sr620".

6. Configure the Application Manifest.

    Open the app\_manifest.json in the directory matching the board type
    e.g. mt3620-dk/app\_manifest.json
    
    * Follow the instructions for the [BACNet][7] or [EthernetIP][8] example
      to configure the example application in the example Git repo.
      See [Use the Example Code][6].
	
7. Attach your Azure Sphere development board to your PC with the USB cable.

8. Start a UDP listener (optional). This allow application logging output
   to be viewed as log messages are created.

    * Open a command window or PowerShell.

    * Issue the command:
   PC running ncat.

    ```console
    ncat -l 1999 --keep-open --udp --recv-only

    ```

9. Configure the digital twin. See [Configuring XRT Using a Device Twin][9].

10. Build the application.

    * Select the VSCode CMake view in the Activity Bar (left most column).
    * Click the "Build" button in the Status Bar (bottom of window).
    
11. Deploy and Debug the application.

    * Select the VSCode Run and Debug view in the Activity Bar (left
      most column).
    * Press F5. The application will be downloaded to your Azure Sphere board
      and the application started under control of the debugger.
