# App2 - Sparkplug Application (container)

XRT linked in as a library, running only as a Sparkplug application: the
standard XRT Sparkplug config minus device services and Sparkplug node, the
same way the `iotechsys/connect-opc-ua-server` image is put together. It has
no Sparkplug node identity of its own, so it sees every node and device in the
group (`xrt` from App1, `xrt1` from `xrt-standalone`) through the MQTT broker.

The app itself is the demo Sparkplug application component shared with App1
(`App::SparkplugDemo`, [`../common/spg_demo_app.c`](../common/spg_demo_app.c)),
which logs every metric and issues a `DCMD` write to `Dev3` once it's born.

## Building

Built automatically by `docker compose up --build` from [`../`](../), using
`../` (not this directory) as the build context - the `Dockerfile` needs to
reach [`../common/`](../common/) too.
To build just this image directly:

```bash
cd Library
docker build -t app2-standalone -f app2-standalone/Dockerfile .
```

## Config

App2 has no config directory. Its XRT component config is compiled into
`spg_standalone` as C string constants in
[`deployment_config.h`](deployment_config.h), and handed to XRT by the config
loader in [`../common/main.c`](../common/main.c).

It's all defined in [`deployment.pkl`](deployment.pkl). **FOR NOW:**
`deployment_config.h` is kept in step with it by hand, since the XRT Pkl schema
can't render C strings yet. With no device services there's no state for
`../generate-pkl-config.sh` to write out.
