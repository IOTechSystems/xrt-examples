# Basic Tutorial - Part 1: Install, Configure and Run Xrt

The completed project for Part 1 of the Edge Connect Basic Tutorial. The step-by-step guide is in the Edge
Connect documentation, under **Getting Started > Tutorials > Basic Tutorial**.

Xrt reads a simulated BACnet office zone controller through the BACnet/IP Device Service, and publishes its
data on an MQTT broker as Sparkplug B.

| Path | What it is |
|---|---|
| `compose.yml` | MQTT broker, BACnet Simulator and Sparkplug Client web UI |
| `mosquitto/mosquitto.conf` | Broker configuration (anonymous access - tutorial only) |
| `simulator/office-zone.lua` | Simulator script: zone temperature, setpoint, occupancy and fan |
| `PklProject`, `deployment.pkl` | PKL node description the Xrt configuration is generated from |
| `deployment/config/`, `deployment/bacnet_ip/state/` | Xrt configuration generated from `deployment.pkl` |
| `deployment/bacnet_ip/profiles/` | Device profile for the office zone controller |

## Prerequisites

- Linux with Docker and the Docker Compose plugin
- An Edge Connect license file, copied to `license.json` in this directory
- The [PKL CLI](https://pkl-lang.org/main/current/pkl-cli/index.html), only if you change `deployment.pkl`

## Run it

```bash
docker compose up -d
export BACNET_SIM_ADDRESS=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' bacnet-sim)

cat > xrt.env <<EOF
XRT_LICENSE_FILE=/opt/iotech/xrt/3.4/license.json
XRT_DEPLOYMENT_DIR=/opt/iotech/xrt/3.4/deployment
XRT_STATE_DIR=/opt/iotech/xrt/3.4/deployment/state
XRT_MQTT_BROKER=tcp://mqtt-broker:1883
XRT_MQTT_USERNAME=
XRT_MQTT_PASSWORD=
SPARKPLUG_GROUP=tutorial
SPARKPLUG_NODE=xrt-node
SPARKPLUG_PROTO=spb
BACNET_SIM_ADDRESS=$BACNET_SIM_ADDRESS
EOF

docker run -d --name xrt --network xrt-tutorial --env-file xrt.env \
  -v "$PWD/deployment:/opt/iotech/xrt/3.4/deployment" \
  -v "$PWD/license.json:/opt/iotech/xrt/3.4/license.json:ro" \
  iotechsys/xrt:3.4.6-deb13
```

Open the Sparkplug Client web UI at <http://localhost:8090> to see the office zone's data.

To regenerate the configuration after changing `deployment.pkl`:

```bash
pkl project resolve .
pkl eval -m deployment deployment.pkl
```

Stop everything with:

```bash
docker rm -f xrt
docker compose down
```
