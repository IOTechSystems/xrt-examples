/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Colocated Sparkplug client for XRT 3.4.
 *
 * XRT (config, bus, a Virtual Device Service, a BACnet/IP Device Service,
 * MQTT bridge and Sparkplug node) is baked into this one process alongside
 * a Sparkplug Application (xrt_spg_app), so the business logic below
 * reaches decoded Sparkplug Node/Device/Metric state directly via
 * in-process callbacks rather than over a request/reply protocol. Two
 * different protocols (Virtual, BACnet/IP) feed into the one Sparkplug
 * node/application pair, showing multiple device services aggregated
 * under a single Sparkplug identity.
 *
 * Data flow: device schedules -> bus telemetry -> Sparkplug node (encodes
 * NBIRTH/DBIRTH/DDATA) -> MQTT bridge -> real broker -> MQTT bridge
 * (decodes back in, raw protobuf) -> Sparkplug application (decodes
 * protobuf, tracks Node/Device/Metric state, fires callbacks).
 */

#include <inttypes.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "xrt/sparkplug.h"
#include "sparkplug/sparkplug_app.h"

#define WRITE_DEVICE "Virtual-Device"
#define WRITE_METRIC "StoreInt32Value"
#define WRITE_VALUE 456

static atomic_bool stopped = ATOMIC_VAR_INIT (false);

/*
 * XRT::SparkplugNode (libxrt-sparkplug.so) references `xrt_exit_delay` as
 * extern, but it is only defined in xrt.c, which is compiled into the
 * standalone `xrt` executable rather than into any library. A colocated
 * host process must provide it itself, or loading libxrt-sparkplug.so
 * fails with "undefined symbol: xrt_exit_delay". Requires linking with
 * -rdynamic so libxrt-sparkplug.so can resolve it back from this
 * executable's own symbol table.
 */
atomic_uint_fast64_t xrt_exit_delay = ATOMIC_VAR_INIT (0u);

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
  /* Virtual device service, MQTT bridge and Sparkplug node are loaded
   * dynamically per their "Library"/"Factory" config fields. The Sparkplug
   * config type has no such fields (matches other XRT deployments) so it
   * must be registered here. */
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

/* Fired when any device (virtual or BACnet/IP) births under a node. */
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
  iot_log_info (ctx->logger, "issuing DCMD: '%s' = %d", WRITE_METRIC, WRITE_VALUE);
  xrt_spg_app_device_send_cmd (device, metric, iot_data_alloc_i32 (WRITE_VALUE));
}

int main (void)
{
  iot_container_t *container = init_xrt (getenv ("XRT_CONFIG_DIR"));
  if (container == NULL)
  {
    return 1;
  }
  iot_container_start (container);

  xrt_bus_t *bus = (xrt_bus_t *) iot_container_find_component (container, "bus");
  xrt_bus_add_ref (bus);
  iot_logger_t *logger = (iot_logger_t *) iot_container_find_component (container, "logger");
  iot_logger_add_ref (logger);
  iot_threadpool_t *spg_pool = (iot_threadpool_t *) iot_container_find_component (container, "spgapp_pool");
  iot_threadpool_add_ref (spg_pool);

  demo_ctx_t ctx = {.logger = logger, .device_written = ATOMIC_VAR_INIT (false)};

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
