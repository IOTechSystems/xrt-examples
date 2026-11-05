# InfluxDB exporter example

## Example

This example uses the virtual device service to produce readings exported by the InfluxDB exporter to an InfluxDB-2.x bucket.

Device services publish their data as Sparkplug, so the exporter is configured with `SparkplugConfig`, to run a Sparkplug application that exports each device resource value as a field of the device name measurement (tagged with the device and schedule names). The node is a standard (Sparkplug) node, as its Sparkplug node publishes the NBIRTH that the Sparkplug application requires, so an MQTT broker is also required.

The configuration is generated from `deployment.pkl` (see the `@XRT/export/influxdb.pkl` module for the exporter options). To use InfluxDB-1.x, set `influx_version = 1` and replace the `bucket`, `org` and `token` options with `db_name` (and `auth_enabled`, `user_name` and `password` if authentication is enabled).

## Steps

**Set Environment Variables**

XRT_INFLUXDB_SERVICE - The URL of the InfluxDB service e.g

```bash
export XRT_INFLUXDB_SERVICE=http://localhost:8086
```

XRT_INFLUXDB_USERNAME and XRT_INFLUXDB_PASSWORD - The InfluxDB admin username and password e.g

```bash
export XRT_INFLUXDB_USERNAME=admin
export XRT_INFLUXDB_PASSWORD=influxdb2_admin
```

XRT_INFLUXDB_BUCKET - The name of the InfluxDB bucket e.g.

```bash
export XRT_INFLUXDB_BUCKET=test_bucket
```

XRT_INFLUXDB_ORG - The name of the InfluxDB organisation e.g.

```bash
export XRT_INFLUXDB_ORG=IOTechSys
```

XRT_INFLUXDB_TOKEN - The API token used to write to the bucket e.g.

```bash
export XRT_INFLUXDB_TOKEN=xrt-example-token
```

Set commonly used environment variables (including the MQTT broker, `XRT_MQTT_BROKER`, and Sparkplug node, `SPARKPLUG_NODE`)

```bash
cd Exporters/influxdb
. ../../set_env_vars.sh
```

**Run an MQTT broker**

```bash
docker run --rm --detach --name xrt-mosquitto -p 1883:1883 eclipse-mosquitto:2 mosquitto -c /mosquitto-no-auth.conf
```

**Run InfluxDB-2.x**

```bash
docker run --rm --detach --name xrt-influxdb -p 8086:8086 \
  -e DOCKER_INFLUXDB_INIT_MODE=setup \
  -e DOCKER_INFLUXDB_INIT_USERNAME=${XRT_INFLUXDB_USERNAME} \
  -e DOCKER_INFLUXDB_INIT_PASSWORD=${XRT_INFLUXDB_PASSWORD} \
  -e DOCKER_INFLUXDB_INIT_ORG=${XRT_INFLUXDB_ORG} \
  -e DOCKER_INFLUXDB_INIT_BUCKET=${XRT_INFLUXDB_BUCKET} \
  -e DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=${XRT_INFLUXDB_TOKEN} \
  influxdb:2.4
```

**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

- XRT is installed
- LD_LIBRARY_PATH has been correctly set
- XRT_LICENSE_FILE has been set to the location of the xrt license

```bash
xrt deployment/config
```

> **Note** Xrt must be run from this context as the configuration files use relative pathnames

**View the exported data**

```bash
docker exec xrt-influxdb influx query --org ${XRT_INFLUXDB_ORG} --token ${XRT_INFLUXDB_TOKEN} \
  "from(bucket: \"${XRT_INFLUXDB_BUCKET}\") |> range(start: -5m) |> filter(fn: (r) => r._measurement == \"Motor\")"
```
