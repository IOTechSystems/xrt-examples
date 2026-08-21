# Using XRT as a Library

This folder contains examples of embedding XRT directly into your own C
program, rather than running XRT as its own `xrt` process. Baking XRT into
your process this way lets you start it, exchange data with it, and cleanly
stop it as part of your own application's lifecycle — useful for
integrating XRT into existing business logic rather than treating it as an
external service you talk to.

## sparkplug-colocated

[`sparkplug-colocated/`](sparkplug-colocated/README.md) is the current
example: a Virtual Device Service, a BACnet/IP Device Service,
`XRT::MQTTBridge` and `XRT::SparkplugNode` all run inside one process,
alongside a Sparkplug Application (`xrt_spg_app_t`) created directly in C
via `sparkplug/sparkplug_app.h`. The C program reaches decoded Sparkplug
Node/Device/Metric state through in-process callbacks — no request/reply
protocol involved — and the whole pipeline round-trips through a real MQTT
broker using real Sparkplug B protobuf. Two different source protocols
(Virtual, BACnet/IP) feed into the same Sparkplug node, showing multiple
device services aggregated under one Sparkplug identity. See its README for
the full data-flow diagram, prerequisites and build/run instructions.

## Standalone Sparkplug client (concept, not yet implemented)

A natural companion to `sparkplug-colocated/` is a *standalone* Sparkplug
client: rather than being baked into the same process as XRT, it would run
as its own separate binary/process, with XRT (device services + Sparkplug
node + MQTT bridge) running independently as its own `xrt` deployment —
potentially on a different host entirely.

The two designs share the same Sparkplug Application SDK
(`xrt_spg_app_*`); what differs is the process boundary:

- **Colocated** (this folder, today): one process, one `iot_container`,
  everything sharing memory — the app reads decoded Sparkplug state
  in-process.
- **Standalone** (not yet built): the client owns its own small
  `iot_container` (bus + `XRT::MQTTBridge` + `xrt_spg_app_t`), separate from
  the process running the actual device services/Sparkplug node. It reaches
  XRT purely over MQTT — subscribing to the Sparkplug B topics XRT's own
  bridge publishes, and issuing `NCMD`/`DCMD` writes the same way.

This has been deliberately parked rather than built speculatively, since it
hinges on a call only the consumer of this repo can make: whether the
standalone client should depend on XRT's own Sparkplug SDK at all (own
`iot_container` + `xrt_spg_app`, just as a separate process), or be a fully
independent implementation with no XRT/iot dependency (e.g. a plain MQTT
client plus raw Sparkplug B protobuf decode). That choice drives the
language, dependencies and structure of the whole example, so it's worth
deciding deliberately rather than guessing.
