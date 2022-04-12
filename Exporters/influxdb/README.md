# InfluxDB exporter example

## Example

This example uses the virtual device service to produce readings exported by the 'influxdb exporter'.
Please note that the example illustrates the use of the batch transform component that aggregates the readings based on the configured buffer size/timeout to optimize write to the InfluxDB.

## Steps 

**Set Environment Variables**

XRT_INFLUXDB_SERVICE - The address of the influx database e.g

```bash
export XRT_INFLUXDB_SERVICE=xrt-influxdb:8086
```

XRT_INFLUXDB_USERNAME - The username for the influx database e.g

```bash
export XRT_INFLUXDB_USERNAME=admin
```

XRT_INFLUXDB_PASSWORD - The password for the influx database e.g

```bash
export XRT_INFLUXDB_PASSWORD=admin
```
XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/influxdb/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/influxdb/deployment/state/
```

**Run InfluxDB**

```bash
  docker run --rm --detach --name xrt-influxdb -e "INFLUXDB_HTTP_AUTH_ENABLED=true" -e "INFLUXDB_ADMIN_USER=${XRT_INFLUXDB_USERNAME}" -e "INFLUXDB_ADMIN_PASSWORD=${XRT_INFLUXDB_PASSWORD}" influxdb:1.8
```
**Run XRT with the config folder:**

This is assuming that the following pre-requisites are satisfied:

* XRT is installed
* LD_LIBRARY_PATH has been correctly set
* XRT_LICENSE_FILE has been set to the location of the xrt license 

```bash
cd influxdb
xrt deployment/config
```
