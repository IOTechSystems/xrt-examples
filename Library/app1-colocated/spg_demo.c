/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Colocated Sparkplug client for XRT 3.4 ("App1" in the reference
 * architecture: XRT linked in as a library, running inside its own
 * container).
 *
 * A Virtual Device Service, XRT::MQTTBridge and XRT::SparkplugNode all run
 * inside this one process alongside a Sparkplug Application (xrt_spg_app_t)
 * created directly in C via sparkplug/sparkplug_app.h, so the business logic
 * below reaches decoded Sparkplug Node/Device/Metric state directly via
 * in-process callbacks rather than over a request/reply protocol. Two
 * separate BACnet/IP Device Service instances (Dev1, Dev2 - each talking to
 * its own simulator container) feed into the one Sparkplug node/application
 * pair, showing multiple devices of the same protocol aggregated under a
 * single Sparkplug identity.
 *
 * Data flow: device schedules -> bus telemetry -> Sparkplug node (encodes
 * NBIRTH/DBIRTH/DDATA) -> MQTT bridge -> real broker -> MQTT bridge
 * (decodes back in, raw protobuf) -> Sparkplug application (decodes
 * protobuf, tracks Node/Device/Metric state, fires callbacks).
 */

#include <ctype.h>
#include <dirent.h>
#include <inttypes.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "xrt/sparkplug.h"
#include "sparkplug/sparkplug_app.h"

#define WRITE_DEVICE "Dev1"
#define WRITE_METRIC "analog_output_0:present-value"
#define WRITE_VALUE 456.0f

static atomic_bool stopped = false;

/*
 * XRT::SparkplugNode (libxrt-sparkplug.so) references `xrt_exit_delay` as
 * extern, but it is only defined in xrt.c, which is compiled into the
 * standalone `xrt` executable rather than into any library. A colocated
 * host process must provide it itself, or loading libxrt-sparkplug.so
 * fails with "undefined symbol: xrt_exit_delay". Requires linking with
 * -rdynamic so libxrt-sparkplug.so can resolve it back from this
 * executable's own symbol table.
 */
atomic_uint_fast64_t xrt_exit_delay = 0u;

typedef struct
{
  iot_logger_t *logger;
  atomic_bool device_written;
} demo_ctx_t;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
}

/*
 * NodeConfig.deployment() (xrt's Pkl deployment schema, core/XRT.pkl)
 * relabels every component with a numeric prefix (e.g. "bus" -> "08-bus"),
 * for both the filename and the component's own registered id - and
 * iot_container_init() loads main.json into a sorted map, so that prefix is
 * what makes its key order (alphabetical) match real dependency order.
 * Stripping it at config-generation time (as an earlier version of
 * generate-pkl-config.sh did) throws that load-order guarantee away, so
 * instead resolve the real, still-prefixed id here at startup: scan
 * config_dir for the one file whose name, after stripping any leading
 * "<digits>-", matches plain_name exactly.
 */
static char *resolve_component_id (const char *config_dir, const char *plain_name)
{
  char *result = NULL;
  DIR *dir = opendir (config_dir);
  if (dir == NULL)
  {
    return NULL;
  }

  size_t name_len = strlen (plain_name);
  struct dirent *entry;
  while ((entry = readdir (dir)) != NULL)
  {
    const char *fname = entry->d_name;
    size_t flen = strlen (fname);
    static const char ext[] = ".json";
    size_t ext_len = sizeof (ext) - 1;
    if (flen <= ext_len || strcmp (fname + flen - ext_len, ext) != 0)
    {
      continue;
    }

    const char *stem_end = fname + (flen - ext_len);
    const char *base = fname;
    while (base < stem_end && isdigit ((unsigned char) *base))
    {
      base++;
    }
    base = (base > fname && base < stem_end && *base == '-') ? base + 1 : fname;

    size_t base_len = (size_t) (stem_end - base);
    if (base_len == name_len && strncmp (base, plain_name, name_len) == 0)
    {
      result = strndup (fname, flen - ext_len);
      break;
    }
  }
  closedir (dir);
  return result;
}

static inline iot_container_t *init_xrt (char *config_uri)
{
  struct sigaction signal_action = {0};
  signal_action.sa_handler = signal_handler;
  signal_action.sa_flags = SA_RESETHAND;
  sigaction (SIGINT, &signal_action, NULL);
  sigaction (SIGTERM, &signal_action, NULL);
  sigaction (SIGHUP, &signal_action, NULL);

  iot_container_config_t config = {.load = iot_store_config_load, .uri = config_uri, .save = iot_store_config_save};
  iot_container_config (&config);
  iot_container_t *container = iot_container_alloc ("main");

  iot_component_factory_add (iot_logger_factory ());
  iot_component_factory_add (iot_threadpool_factory ());
  iot_component_factory_add (iot_scheduler_factory ());
  iot_component_factory_add (xrt_bus_factory ());
  iot_component_factory_add (xrt_config_factory ());
  /* BACnet/IP device services, the MQTT bridge and the Sparkplug node are
   * loaded dynamically per their "Library"/"Factory" config fields. The
   * Sparkplug config type has no such fields (matches other XRT
   * deployments) so it must be registered here. */
  iot_component_factory_add (xrt_sparkplug_config_factory ());

  iot_container_init (container);
  return container;
}

/* Fired for every metric value change on a node or device (birth, data, stale). */
static void on_metric_value_updated (xrt_spg_app_metric_t *metric, void *app_ctx)
{
  demo_ctx_t *ctx = app_ctx;
  const iot_data_t *value = xrt_spg_app_metric_get_value (metric);
  /* A metric can be born/updated with no value (is_null); iot_data_to_json
   * requires non-NULL input, so fall back to the literal "null" here. */
  char *json = value ? iot_data_to_json (value) : strdup ("null");
  iot_log_info (ctx->logger, "metric '%s' = %s (ts=%" PRIu64 ")", xrt_spg_app_metric_name (metric), json, xrt_spg_app_metric_get_timestamp (metric));
  free (json);
}

/* Fired when either BACnet/IP device (Dev1 or Dev2) births under a node. */
static void on_device_added (xrt_spg_app_node_t *node, void *app_ctx, xrt_spg_app_device_t *device)
{
  demo_ctx_t *ctx = app_ctx;
  iot_log_info (ctx->logger, "device '%s' born on node '%s'", xrt_spg_app_device_name (device), xrt_spg_app_node_get_id (node));
}

/* Fired for each metric as a device's birth populates its metric store.
 * Used here to demonstrate issuing a DCMD write back to one specific
 * device/metric (WRITE_DEVICE/WRITE_METRIC) via the Sparkplug application,
 * as soon as that metric becomes available.
 *
 * NOTE: on_device_added (above) fires before the device's metric store is
 * populated from the birth, so xrt_spg_app_device_get_metric always
 * returns NULL if called from there -- the write has to happen from a
 * per-metric callback like this one instead. */
static void on_device_metric_added (xrt_spg_app_device_t *device, xrt_spg_app_metric_t *metric, void *app_ctx)
{
  demo_ctx_t *ctx = app_ctx;
  if (strcmp (xrt_spg_app_device_name (device), WRITE_DEVICE) != 0 || strcmp (xrt_spg_app_metric_name (metric), WRITE_METRIC) != 0)
  {
    return;
  }
  if (atomic_exchange (&ctx->device_written, true))
  {
    return;
  }
  iot_log_info (ctx->logger, "issuing DCMD: '%s' = %f", WRITE_METRIC, (double) WRITE_VALUE);
  xrt_spg_app_device_send_cmd (device, metric, iot_data_alloc_f32 (WRITE_VALUE));
}

int main (void)
{
  const char *config_dir = getenv ("XRT_CONFIG_DIR");
  iot_container_t *container = init_xrt ((char *) config_dir);
  if (container == NULL)
  {
    return 1;
  }
  iot_container_start (container);

  char *bus_id = resolve_component_id (config_dir, "bus");
  char *logger_id = resolve_component_id (config_dir, "logger");
  char *spgapp_pool_id = resolve_component_id (config_dir, "spgapp_pool");

  xrt_bus_t *bus = (xrt_bus_t *) iot_container_find_component (container, bus_id ? bus_id : "bus");
  xrt_bus_add_ref (bus);
  iot_logger_t *logger = (iot_logger_t *) iot_container_find_component (container, logger_id ? logger_id : "logger");
  iot_logger_add_ref (logger);
  iot_threadpool_t *spg_pool = (iot_threadpool_t *) iot_container_find_component (container, spgapp_pool_id ? spgapp_pool_id : "spgapp_pool");
  iot_threadpool_add_ref (spg_pool);

  free (bus_id);
  free (logger_id);
  free (spgapp_pool_id);

  demo_ctx_t ctx = {.logger = logger, .device_written = false};

  xrt_spg_app_config_t app_cfg = xrt_spg_app_config_default;
  app_cfg.app_id = "XRTLibSparkplugDemo";
  app_cfg.namespace = "spBv1.0";
  app_cfg.group = getenv ("SPARKPLUG_GROUP") ? getenv ("SPARKPLUG_GROUP") : "iotech";
  app_cfg.ctx = &ctx;
  app_cfg.callbacks.on_device_added = on_device_added;
  app_cfg.callbacks.on_device_metric_added = on_device_metric_added;
  app_cfg.callbacks.on_metric_value_updated = on_metric_value_updated;

  xrt_spg_app_t *spg_app = xrt_spg_app_new (bus, &app_cfg, NULL, spg_pool, logger);
  if (spg_app == NULL || !xrt_spg_app_start (spg_app))
  {
    iot_log_error (logger, "failed to start sparkplug application");
    return 1;
  }

  while (!atomic_load (&stopped))
  {
    sleep (1);
  }

  xrt_spg_app_stop (spg_app);
  xrt_spg_app_free (spg_app);
  iot_threadpool_free (spg_pool);
  iot_logger_free (logger);
  xrt_bus_free (bus);
  iot_container_stop (container);
  iot_container_free (container);
  return 0;
}
