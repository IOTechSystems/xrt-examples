# Using XRT as a Library

This folder contains a single `docker compose` that deploys two instances of
XRT: one linked as a library in a custom C app, one running as a plain docker
container; connecting to four BACnet devices through an MQTT broker.

```
                          App3 - EC OPC UA browser  (opc-ua-browser)
                                     |
                          EC OPC UA Server  (xrt-opc-ua-server)
                                     |
                       ============ MQTT Sparkplug bus ============
                                  (mosquitto)
                     /                                   \
           Pub DDATA Dev1-2                       Pub DDATA Dev3-4
           Sub DCMDs Dev1-2                       Sub DCMDs Dev3-4
                 |                                         |
     +-----------------------+                +-----------------------+
     | App1 (container)      |                | EC Xrt (container)    |
     |  EC Xrt (library)     |                |  = xrt-standalone     |
     +-----------------------+                +-----------------------+
        |            |                            |            |
   BACnet/IP     BACnet/MSTP                  BACnet/IP    BACnet/MSTP
     Dev1           Dev2                         Dev3          Dev4

  App2 (container, EC Xrt library as a Sparkplug application only) subscribes
  to Dev1-4 across the whole bus, independent of the two Xrt instances above it.
```

## Components

| Diagram element | Directory / image | What it is |
|---|---|---|
| App1 (container) | [`app1-colocated/`](app1-colocated/README.md) | Custom C binary, XRT linked in as a library: a standard XRT Sparkplug node talking to Dev1 + Dev2 & the MQTT broker, plus the demo Sparkplug application component (`common/`) |
| EC Xrt (container) | [`xrt-standalone/`](xrt-standalone/README.md) | Stock Debian XRT image (`XRT_IMAGE`, the same XRT image as App1/App2), talks to Dev3 + Dev4 & MQTT broker |
| App2 (container) | [`app2-standalone/`](app2-standalone/README.md) | Custom C binary, XRT linked in as a library: the standard XRT Sparkplug config minus device services and Sparkplug node, plus the same demo Sparkplug application component, consuming Dev1-4 through the MQTT broker |
| Demo Sparkplug application | [`common/`](common/) | `App::SparkplugDemo`, an XRT component built the same way as `XRT::OPCUAServer`: the container hands it a Bus/ThreadPool/Logger and it does everything through the `xrt_spg_app` API. Shared by App1 and App2, along with the `main.c` that runs the container |
| MQTT Sparkplug bus | `mosquitto` service (`mosquitto/mosquitto.conf`) | Eclipse Mosquitto broker |
| EC OPC UA Server | `xrt-opc-ua-server` service (`OPCUA_IMAGE`, see [Dependencies](#dependencies)) | The `iotechsys/connect-opc-ua-server` image as-is, configured by environment in `docker-compose.yml`: `XRT::OPCUAServer` with Sparkplug enabled, subscribes to Dev1-4 |
| App3 - EC OPC UA browser | `opc-ua-browser` service (`iotechsys/opc-ua-browser:1.1`) | Web UI at `localhost:8080` |
| Dev1 / Dev3 (BACnet/IP) | `bacnet-sim-dev1` / `bacnet-sim-dev3` services (`iotechsys/bacnet-sim:2.2`) | BACnet/IP simulator |
| Dev2 / Dev4 (BACnet/MSTP) | `bacnet-sim-dev2` / `bacnet-sim-dev4` services (`iotechsys/bacnet-sim:2.2`) | BACnet/MSTP simulator |

## License

XRT needs a valid license file at runtime. Every service that runs XRT
(`app1`, `app2`, `xrt-standalone`, `xrt-opc-ua-server`) mounts `./license`
read-only to `/license` and sets `XRT_LICENSE_FILE=/license/xrt.lic`. Before
running anything, place your own license file at:

```
Library/license/xrt.lic
```

## Dependencies

Both custom-binary components (`app1-colocated`, `app2-standalone`) are
compiled against XRT's public headers, and use only its public Sparkplug
application API (`sparkplug/sparkplug_app.h`). They, and `xrt-standalone`, are
built on a Debian/Ubuntu XRT image, picked by `XRT_IMAGE`:

- the image has the XRT and IOT runtime packages installed, with everything
  they depend on (Paho MQTT C, Sparkplug B, BACnet, ...), so each app's image
  is just that image plus the app
- the apps are compiled against the headers in the `-dev` packages of the
  image's XRT and IOT packages (e.g. `iotech-xrt-4.0-dev` and
  `iotech-iot-1.7-dev`), from IOTech's public apt repository
  (`iotech.jfrog.io/iotech/debian-release`).

Images are pinned to their major.minor version: XRT (`XRT_IMAGE`) is
`iotechsys/xrt:4.0-deb13` and the OPC UA Server (`OPCUA_IMAGE`) is
`iotechsys/connect-opc-ua-server:4.0`.

| Dependency | Version | Why |
|---|---|---|
| XRT | **4.0** | core library |
| IOT | **1.7** | core library |
| Paho MQTT C (`paho-mqtt3as`) | **1.3.162** | runtime only, for XRT's MQTT bridge |
| Sparkplug B (`sparkplug-b`) | **1.0.1** | runtime only, the protobuf codec for XRT's Sparkplug transform |
| XRT Pkl package | **4.0.0** | the `deployment.pkl` schema, downloaded from `iotech.jfrog.io` (see [`PklProject`](PklProject)) |

## Running it

Firstly, ensure all dependencies (above) are met.

All XRT config (component config, devices and schedules) is defined in each
app's `deployment.pkl` (for App1 and App2, the component config is generated
as a C header, `deployment_config.h`, compiled into the app) and none of the
generated files are committed, so generate them first (see
[`generate-pkl-config.sh`](generate-pkl-config.sh) for what it needs):

```bash
cd Library
./generate-pkl-config.sh
docker compose up --build
```

This builds `app1-colocated`, `app2-standalone` and `xrt-standalone`
(pulling the `XRT_IMAGE` and `OPCUA_IMAGE` images, `iotechsys/opc-ua-browser:1.1`,
`iotechsys/bacnet-sim:2.2` and `eclipse-mosquitto:2.0` as-is) and
starts all ten services.

Expected log output:

- `bacnet-sim-dev1`..`dev4` come up and start responding to requests:
  `Dev1`/`Dev3` over BACnet/IP, `Dev2`/`Dev4` over BACnet MSTP.
- `app1` births `Dev1`/`Dev2` under Sparkplug node `xrt`, then issues its
  demo `DCMD` write to `Dev1`'s `analog_output_0:present-value`.
- `xrt-standalone` births `Dev3`/`Dev4` under Sparkplug node `xrt1`.
- `app2` logs metrics from *both* Sparkplug nodes (`xrt` and `xrt1`) -
  proof that it's a group-wide Sparkplug application, independent of either
  Xrt instance - then issues its demo `DCMD` write to `Dev3` (on
  `xrt-standalone`) over MQTT.
- `xrt-opc-ua-server` births as an OPC UA Server exposing `Dev1`-`Dev4`.

Then open the OPC UA browser at <http://localhost:8080>, connect to
`opc.tcp://xrt-opc-ua-server:4840` (no security - click through the
warning), and browse to see `Dev1`-`Dev4` and their metrics. Writing a value
from the browser publishes a `DCMD` back out over the bus.

Stop everything with `docker compose down`.
