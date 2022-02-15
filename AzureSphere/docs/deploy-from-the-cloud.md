# Deploy From The Cloud

Using the azsphere command line tool, built images can be
sent to the Cloud and then deployed from the Cloud using
a deployment group which is linked to your Azure Sphere
Hardware. To build an image that can be used for Cloud
deployment, follow the below steps:

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
DEVICE=<modbus, bacnet or virtual> \
BOARD=<mt3620-g100, mt3620-dk, mt3620-sk or mt3620-sr620>
```

Now the image has been built and can be deployed to the cloud.
The built image `xrt-app.imagepackage` can now be found in the
build/ directory of your current directory.

To deploy the image from the Cloud, follow the [Create A Deployment](https://docs.microsoft.com/en-us/azure-sphere/deployment/create-a-deployment?tabs=cliv2beta)
guide.

