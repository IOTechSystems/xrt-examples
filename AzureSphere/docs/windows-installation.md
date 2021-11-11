# Installing the XRT Package on Windows

To install XRT Azure Sphere, complete the following steps:

1. Install the Azure Sphere SDK. For further information on
   installing the Azure SDK on Windows 10, refer to the
   [Windows installation quickstart](https://docs.microsoft.com/en-gb/azure-sphere/install/install-sdk?pivots=visual-studio)
   section of the Azure Sphere documentation

2. Download the XRT .zip package from the IOTech repository,
   using the following command:

```bat
curl -L -O https://iotech.jfrog.io/artifactory/windows-release/iotech-xrt-dev-azsphere8-1.1.2.zip
```

3. Open Windows File Explorer

4. Select the downloaded .zip package and extract the files
   to the following location:

`C:\Program Files (x86)\Microsoft Azure Sphere SDK\Sysroots\8`

## Visual Studio Setup

* Open Visual Studio and install Visual Studio Extensions for
  Azure Sphere

From this point after the Application has been configured
(see later) it can be built either from within Visual Studio
or via the Visual Studio Command Prompt.

