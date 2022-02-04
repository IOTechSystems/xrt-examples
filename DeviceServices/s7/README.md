# XRT Config Examples

This document is to help you run the example XRT config that is provided.

First navigate to device-s7-c/xrt/example-configs/

Run XRT with the config folder:

```
$ xrt s7-device-service/config
```
## Running S7 Server
Start the S7 Server:
```shell script
docker run --rm --name=s7-server iotechsys/dev-edgexpert-s7-test-server:1.8.dev
```

Find the IP of the server:
```shell script
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' s7-server
```

Use this IP address in the Device Protocols for example:
```shell script
{
  "S7-Server":{
    "profile":"Server",
    "protocols":{
      "S7":{
        "IP" : <s7-server-IP-address>,
        "Rack" : 0,
        "Slot" : 2
      }
    }
  }
}
```
