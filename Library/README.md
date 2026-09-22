# Using XRT as a Library

This folder is a single `docker compose` deployment of the reference
"BACnet Dual-Path" architecture: two Xrt instances (one linked in as a
library, one running as its own stock container) serving four BACnet
devices, bridged through a Sparkplug MQTT bus to an OPC UA Server for
supervisory access.

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
   BACnet/IP     BACnet/IP                    BACnet/IP    BACnet/IP
     Dev1           Dev2                         Dev3          Dev4

  App2 (container, standalone Sparkplug client) subscribes to Dev1-4 across
  the whole bus, independent of the two Xrt instances above it.
```

> Dev2 and Dev4 are created as BACnet/IP here instead of MSTP for simplicity.

## Components

| Diagram element | Directory / image | What it is |
|---|---|---|
| App1 (container) | [`app1-colocated/`](app1-colocated/README.md) | Custom C binary (`spg_demo.c`), XRT linked in as a library, talks to Dev1 + Dev2 |
| EC Xrt (container) | [`xrt-standalone/`](xrt-standalone/README.md) | Stock `iotechsys/xrt-server:3.4.6` image, no custom app, talks to Dev3 + Dev4 |
| App2 (container) | [`app2-standalone/`](app2-standalone/README.md) | Custom C binary (`spg_standalone.c`), plain MQTT/Sparkplug client, no XRT bus, subscribes to Dev1-4 |
| MQTT Sparkplug bus | `mosquitto` service (`mosquitto/mosquitto.conf`) | Eclipse Mosquitto broker |
| EC OPC UA Server | [`xrt-opc-ua-server/`](xrt-opc-ua-server/README.md) | Purpose-built `iotechsys/connect-opc-ua-server` image (config baked in, no mounted JSON files), `XRT::OPCUAServer` with `EnableSparkplug: true`, subscribes to Dev1-4 |
| App3 - EC OPC UA browser | `opc-ua-browser` service (`iotechsys/opc-ua-browser:1.1`) | Web UI at `localhost:8080` |
| Dev1 / Dev3 (BACnet/IP) | `bacnet-sim-dev1` / `bacnet-sim-dev3` services (`iotechsys/bacnet-sim:2.2.7`) | BACnet/IP simulator |
| Dev2 / Dev4 (BACnet/IP) | `bacnet-sim-dev2` / `bacnet-sim-dev4` services (`iotechsys/bacnet-sim:2.2.7`) | BACnet/IP simulator |

## License

XRT needs a valid license file at runtime. Every service that runs XRT
(`app1`, `app2`, `xrt-standalone`, `xrt-opc-ua-server`) mounts `./license`
read-only to `/license` and sets `XRT_LICENSE_FILE=/license/xrt.lic`. Before
running anything, place your own license file at:

```
Library/license/xrt.lic
```

`license/*.lic` is gitignored - never commit a real license file.

## Running it

Firstly, ensure all dependencies (below) are met.

```bash
cd Library
docker compose up --build
```

This builds `app1-colocated`, `app2-standalone` and `xrt-standalone`
(pulling `iotechsys/xrt-server:3.4.6`, `iotechsys/connect-opc-ua-server:3.4.5-dev`,
`iotechsys/opc-ua-browser:1.1` and `iotechsys/bacnet-sim:2.2.7` as-is) and
starts all ten services.

Expected log output:

- `bacnet-sim-dev1`..`dev4` come up and start responding to BACnet/IP
  requests.
- `app1` births `Dev1`/`Dev2` under Sparkplug node `xrt`, then issues its
  demo `DCMD` write to `Dev1`'s `analog_output_0:present-value`.
- `xrt-standalone` births `Dev3`/`Dev4` under Sparkplug node `xrt1`.
- `app2` logs metrics from *both* Sparkplug nodes (`xrt` and `xrt1`) -
  proof that it's a plain group-wide Sparkplug subscriber, independent of
  either Xrt instance.
- `xrt-opc-ua-server` births as an OPC UA Server exposing `Dev1`-`Dev4`.

Then open the OPC UA browser at <http://localhost:8080>, connect to
`opc.tcp://xrt-opc-ua-server:4840` (no security - click through the
warning), and browse to see `Dev1`-`Dev4` and their metrics. Writing a value
from the browser publishes a `DCMD` back out over the bus.

Stop everything with `docker compose down`.

## Dependencies

Both custom-binary components (`app1-colocated`, `app2-standalone`) use
Sparkplug B, which pulls in two libraries beyond the base XRT/IOT install:

Sync the headers from these packages to allow the apps to build with them.

```bash
apt-get install iotech-iot-1.6-dev iotech-libpaho-mqtt-1.3 libsparkplug-b-1.0
./vendor/sync-apt-headers.sh
```

| Dependency | Version | Why |
|---|---|---|
| XRT | **3.4.6** | core library |
| IOT | **1.6.5** | core library |
| Paho MQTT C (`paho-mqtt3as`) | **1.3.162** | Sparkplug B rides on real MQTT |
| Sparkplug B (`sparkplug-b`) | **1.0.1** | the actual protobuf schema/codec for Sparkplug B |

> N.B. paho and sparkplug are available on debian-release but the iot required
> is only available on debian-dev. XRT headers currently manually added since
> there is not yet a `-dev` package available for 3.4
