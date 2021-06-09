# Building On Ubuntu

* Set the `BOARD` variable, in-order to build for your targeted
  Azure Sphere Module, for modbus example `BOARD` will be set to
  `BOARD=mt3620-g100`
* Set the `DEVICE` variable to the intended Device Service,
  for  modbus example `DEVICE` should be set to `DEVICE=modbus`

Issue the command to build XRT:

```bash
make build \
DEVICE=<modbus, bacnet or virtual> \
BOARD=<mt3620-g100, mt3620-dk or mt3620-sk>
```

