# InfluxDB exporter example

## Example

This example uses the virtual device service to produce readings exported by the InfluxDB exporter to an InfluxDB 3 database.

Device services publish their data as Sparkplug, so the exporter is configured with `SparkplugConfig`, to run a Sparkplug application that exports each device resource value as a point in the `sparkplug` measurement, tagged with the Sparkplug `group`, `node`, `device` and `metric`. The value is a field named by its type (`float`, `int`, `bool` or `string`), with its quality in the `quality` field (0 if good). Data is written in batches of up to 128 points, at least once a second. The node is a standard (Sparkplug) node, as its Sparkplug node publishes the NBIRTH that the Sparkplug application requires, so an MQTT broker is also required.

The exporter writes with the InfluxDB v2 compatible write API (`influx_version = 2`), where `bucket` is the InfluxDB 3 database, which is created on the first write, and `token` the InfluxDB 3 token. The configuration is generated from `deployment.pkl` (see the `@XRT/export/influxdb.pkl` module for the exporter options). To use the InfluxDB v1 compatible API instead, set `influx_version = 1` and replace `bucket` and `token` with `db_name`, `auth_enabled = true` and `password` (the token).

## Steps

**Set Environment Variables**

XRT_INFLUXDB_SERVICE - The URL of the InfluxDB service e.g

```bash
export XRT_INFLUXDB_SERVICE=http://localhost:8181
```

XRT_INFLUXDB_DATABASE - The name of the InfluxDB database e.g.

```bash
export XRT_INFLUXDB_DATABASE=xrt
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

**Run InfluxDB 3 Core**

```bash
docker run --rm --detach --name xrt-influxdb -p 8181:8181 influxdb:3-core \
  influxdb3 serve --node-id node0 --object-store memory
```

XRT_INFLUXDB_TOKEN - Create an admin token, once InfluxDB has started, to write and query with

```bash
export XRT_INFLUXDB_TOKEN=$(docker exec xrt-influxdb influxdb3 create token --admin | grep -o 'apiv3_[A-Za-z0-9_-]*' | head -n 1)
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
docker exec xrt-influxdb influxdb3 query --database ${XRT_INFLUXDB_DATABASE} --token ${XRT_INFLUXDB_TOKEN} \
  "SELECT * FROM sparkplug WHERE device = 'Motor' ORDER BY time DESC LIMIT 20"
```
