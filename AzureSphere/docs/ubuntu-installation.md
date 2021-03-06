# Installing the XRT Package on Ubuntu

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
sudo apt-get install iotech-xrt-azsphere8
```
