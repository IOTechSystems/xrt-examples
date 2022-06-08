# Installing the XRT Package on Ubuntu

## Using the package manager (apt)

To install XRT Azure Sphere, complete the following steps.

1. Install package dependencies:

```bash
sudo apt-get update
```

```bash
sudo apt-get install lsb-release apt-transport-https curl gnupg2
```

2. Add the key for the IOTech repository, using the following command:
```bash
curl -fsSL https://iotech.jfrog.io/artifactory/api/gpg/key/public | sudo apt-key add -
```
3. Register the IOTech repository, using the following command:

```bash
echo "deb https://iotech.jfrog.io/iotech/debian-release $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/iotech.list
```

4. Update package information:

```bash
sudo apt update
```

5. Install XRT using the following command:

```bash
sudo apt-get install iotech-xrt-azsphere12
```

## Manual installation

Just like with the [windows installation](./windows-installation.md) we can manually install XRT by extracting the source files in the azure sdk sysroots directory:

1. Install the Azure Sphere SDK for Ubuntu.

2. Download XRT using:

```bat
curl -L -O https://iotech.jfrog.io/ui/native/windows-release/azuresphere-12/iotech-xrt-dev-azsphere12-2.0-latest.zip
```

3. Open the file explorer (nautilus) with sudo permissions

```bash
sudo nautilus ./
```

4. extract the downloaded zip file into the sysroots directory: `/opt/azurespheresdk/Sysroots/<API_VER>/`


## Updating the XRT package on ubuntu

When updating the XRT packages with a newer version, it is recommended that you reinstall the azure sphere SDK to ensure we have a clean sysroots directory.

If XRT was installed using `apt`, please do an `apt remove` before running any `apt-get install` commands.

If XRT was installed manually, the cleanest way to install would be removing the entire sysroots directory that XRT was installed in, and reinstalling the azure sdk.
