# Deploy From The Cloud

Using the azsphere command line tool, images can be built and
then deployed from the cloud using deployments groups that are
linked to your Azure Sphere hardware. To build an image that
can be used for Cloud deployment, follow the below steps:

* Set the `BOARD` variable, in-order to build for your targeted
  Azure Sphere Module, for example with the modbus example `BOARD`
  will be set to `BOARD=mt3620-g100`
* Set the `DEVICE` variable to the intended Device Service,
  for example with modbus example `DEVICE` should be set to
  `DEVICE=modbus`

Issue the command to build XRT, replacing the <placeholders> with
the correct options for your setup:

```bash
make build \
BUILD_TYPE=Release \
DEVICE=<modbus, bacnet or virtual> \
BOARD=<mt3620-g100, mt3620-dk or mt3620-sk>
```

Now the image has been built, an image file can be found in
the build/ directory in your current directory, called
`xrt-app.imagepackage`

To deploy the image from the cloud, follow the [Create a deployment](https://docs.microsoft.com/en-us/azure-sphere/deployment/create-a-deployment?tabs=cliv2beta)
guide.

