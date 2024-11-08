# OPC UA Server examples

## Overview

These example configs demonstrates a colocated Virtual Device Service and an OPC UA Server running on the same Xrt instance, communicating via the internal bus. Note the existence of a `Command` component which is used by the OPC UA Server component to discover the running device service.

## Running the Example

The following instructions assume your working directory is `/xrt-examples/`.

### **Set Environment Variables**

We have provided a script to easily set these environment variables. Run:

```bash
. ./set_env_vars.sh
cd Servers/opc-ua/basic/deployment
```

### **Generate Certificates**

Generate your own `Certificate` and the `PrivateKey`, using [`create_self-signed.py`](https://github.com/open62541/open62541/tree/master/tools/certs).

```bash
python3 create_self-signed.py

```
_Note: In the script, the default `uri` is set to `urn:open62541.server.application`. This should be changed to match the `ApplicationUri` set in the configuration (defaults to `urn:iotechsys:xrt`) before generating the certificates. Additionally, common name (CN), which is set to `open62541Server@localhost` may be updated to align with the applicationuri._

### **Run XRT with the config folder:**

See [Setup XRT](../../DeviceServices/interactive-walkthrough/setup-xrt.md)

Use one of the below configurations to run the OPC UA Server.

#### **Standard Colocated**

```bash
. ./set_env_vars.sh
export OPC_UA_SERVER_CONFIG=opc-ua-server
xrt config
```

#### **With Security Policy Set to Basic256Sha256**

Refer to [Generate Certificates][1] to generate and update `ApplicationUri`, `Certificate` and `PrivateKey` in `config/opc-ua-server-securitypolicy.json`.

```bash
. ./set_env_vars.sh
export OPC_UA_SERVER_CONFIG=opc-ua-server-securitypolicy
xrt config
```

#### **With X.509 certificate**

Refer to [Generate Certificates][1] to generate and Update `ApplicationUri`, `Certificate` and `PrivateKey` in `config/opc-ua-server-x509cert.json`.

```bash
export OPC_UA_SERVER_CONFIG=opc-ua-server-x509cert
xrt config
```

#### **With Username and Password**

Run Xrt with the configuration that sets an access control with a username and password.

```bash
export OPC_UA_SERVER_CONFIG=opc-ua-server-usrpasswd
xrt config
```

## Interacting with the OPC UA Server

See the [OPC UA Server Documentation](https://docs.iotechsys.com/edge-xrt22/server-components/opc-ua-server-component.html)

[1]:#generate-certificates
