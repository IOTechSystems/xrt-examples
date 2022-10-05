# InfluxDB exporter example

## Example

This example uses the virtual device service to produce readings exported by the 'influxdb exporter'.
In this example, config to work with influxdb-1.x (influxdb_exporter.json) and influxdb-2.x (influxdb2_exporter.json) are included. By default main.json is set to influxdb2 configuration.

## Steps 

**Set Environment Variables**

XRT_INFLUXDB_SERVICE - The address of the influx database e.g

```bash
export XRT_INFLUXDB_SERVICE=xrt-influxdb:8086
```

XRT_PROFILE_DIR - This should be the path to the profile directory e.g

```bash
export XRT_PROFILE_DIR=/path/to/xrt-examples/Exporters/influxdb/deployment/profiles/
```

XRT_STATE_DIR - This should be the path to the state directory e.g

```bash
export XRT_STATE_DIR=/path/to/xrt-examples/Exporters/influxdb/deployment/state/
```

XRT_INFLUXDB_USERNAME - The username for the influx database e.g

```bash
export XRT_INFLUXDB_USERNAME=admin
```

XRT_INFLUXDB_PASSWORD - The password for the influx database e.g

```bash
export XRT_INFLUXDB_PASSWORD=admin
```

**Influxdb-2.x Specific Environment Variables**

XRT_INFLUXDB_BUCKET - The name of the influx Bucket e.g.

```bash
export XRT_INFLUXDB_BUCKET=test_bucket
```

XRT_INFLUXDB_ORG - The name of the Organisation e.g.

```bash
export XRT_INFLUXDB_ORG=InfluxOrg
```

XRT_INFLUXDB_TOKEN - Acess Token string to programmatically write to database

```bash
export XRT_INFLUXDB_TOKEN="abcede=="
```

**Run InfluxDB**

**1. Influxdb-1.x**

```bash
  docker run --rm --detach --name xrt-influxdb -e "INFLUXDB_HTTP_AUTH_ENABLED=true" -e "INFLUXDB_ADMIN_USER=${XRT_INFLUXDB_USERNAME}" -e "INFLUXDB_ADMIN_PASSWORD=${XRT_INFLUXDB_PASSWORD}" influxdb:1.8
```

**2. Influxdb-2.x**

To deploy InfluxDB2.0 using Docker -

```bash
  docker run --rm --detach  --name ${INFLUXDB_CONTAINER} influxdb:2.0.7
  
  docker exec ${INFLUXDB_CONTAINER} influx setup \
    --bucket ${XRT_INFLUXDB_BUCKET} \
    --org ${XRT_INFLUXDB_ORG} \
    --password ${XRT_INFLUXDB_USERNAME} \
    --username ${XRT_INFLUXDB_PASSWORD} \
    --force
    
  XRT_INFLUXDB_TOKEN=$(docker exec ${INFLUXDB_CONTAINER} influx auth list | awk -v username=${XRT_INFLUXDB_USERNAME} '$5 ~ username {print $4 " "}')
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
