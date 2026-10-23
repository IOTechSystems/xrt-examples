/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Demo Sparkplug application component - see spg_demo_app.h.
 *
 * Config:
 *   Logger, Bus, ThreadPool  Components to use (required)
 *   AppId                    Sparkplug application id. Default: the XRT::Config NodeId
 *   WriteDevice              Device to issue a one-shot demo DCMD to. Default: none (no write)
 *   WriteMetric              Metric of WriteDevice to write
 *   WriteValue               Float value to write
 *
 * The Sparkplug namespace, group and MQTT bridge app ids come from the
 * deployment's XRT::Sparkplug component, via xrt_spg_app_config_init.
 */

#include <inttypes.h>
#include <stdlib.h>
#include <string.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "sparkplug/sparkplug_app.h"

#include "spg_demo_app.h"

typedef struct spg_demo_app_t
{
  iot_component_t component;
  iot_logger_t *logger;
  iot_threadpool_t *pool;
  xrt_bus_t *bus;
  xrt_spg_app_t *spg_app;
  char *app_id;
  char *write_device;
  char *write_metric;
  double write_value;
  atomic_bool device_written;
} spg_demo_app_t;

/* Fired for every metric value change on a node or device (birth, data, stale). */
static void on_metric_value_updated (xrt_spg_app_metric_t *metric, void *app_ctx)
{
  spg_demo_app_t *app = app_ctx;
  const iot_data_t *value = xrt_spg_app_metric_get_value (metric);
  /* A metric can be born/updated with no value (is_null); iot_data_to_json
   * requires non-NULL input, so fall back to the literal "null" here. */
  char *json = value ? iot_data_to_json (value) : strdup ("null");
  iot_log_info (app->logger, "metric '%s' = %s (ts=%" PRIu64 ")", xrt_spg_app_metric_name (metric), json, xrt_spg_app_metric_get_timestamp (metric));
  free (json);
}

static void on_device_added (xrt_spg_app_node_t *node, void *app_ctx, xrt_spg_app_device_t *device)
{
  spg_demo_app_t *app = app_ctx;
  iot_log_info (app->logger, "device '%s' born on node '%s'", xrt_spg_app_device_name (device), xrt_spg_app_node_get_id (node));
}

/* Fired for each metric as a device's birth populates its metric store.
 * Used here to demonstrate issuing a DCMD write back to one specific
 * device/metric (WriteDevice/WriteMetric) as soon as that metric becomes
 * available.
 *
 * NOTE: on_device_added (above) fires before the device's metric store is
 * populated from the birth, so xrt_spg_app_device_get_metric always
 * returns NULL if called from there -- the write has to happen from a
 * per-metric callback like this one instead. */
static void on_device_metric_added (xrt_spg_app_device_t *device, xrt_spg_app_metric_t *metric, void *app_ctx)
{
  spg_demo_app_t *app = app_ctx;
  if (strcmp (xrt_spg_app_device_name (device), app->write_device) != 0 || strcmp (xrt_spg_app_metric_name (metric), app->write_metric) != 0)
  {
    return;
  }
  if (atomic_exchange (&app->device_written, true))
  {
    return;
  }
  iot_log_info (app->logger, "issuing DCMD: '%s' '%s' = %f", app->write_device, app->write_metric, app->write_value);
  xrt_spg_app_device_send_cmd (device, metric, iot_data_alloc_f32 ((float) app->write_value));
}

static void spg_demo_app_start (spg_demo_app_t *app)
{
  if (!iot_component_set_running (&app->component)) return;
  if (!xrt_spg_app_start (app->spg_app))
  {
    iot_log_error (app->logger, "%s: failed to start sparkplug application", SPG_DEMO_APP_TYPE);
  }
}

static void spg_demo_app_stop (spg_demo_app_t *app)
{
  if (!iot_component_set_stopped (&app->component)) return;
  xrt_spg_app_stop (app->spg_app);
}

static void spg_demo_app_free (spg_demo_app_t *app)
{
  xrt_spg_app_free (app->spg_app);
  xrt_bus_free (app->bus);
  iot_threadpool_free (app->pool);
  iot_logger_free (app->logger);
  free (app->app_id);
  free (app->write_device);
  free (app->write_metric);
  iot_component_fini (&app->component);
  free (app);
}

static iot_component_t *spg_demo_app_config (iot_container_t *container, const iot_data_t *config)
{
  iot_logger_t *logger = (iot_logger_t *) iot_config_component (config, "Logger", container, NULL);
  xrt_bus_t *bus = (xrt_bus_t *) iot_config_component (config, "Bus", container, logger);
  iot_threadpool_t *pool = (iot_threadpool_t *) iot_config_component (config, "ThreadPool", container, logger);
  if (bus == NULL || pool == NULL)
  {
    iot_log_error (logger, "%s: Bus and ThreadPool must be configured", SPG_DEMO_APP_TYPE);
    return NULL;
  }

  spg_demo_app_t *app = calloc (1, sizeof (*app));
  iot_component_init (&app->component, spg_demo_app_factory (), (iot_component_start_fn_t) spg_demo_app_start, (iot_component_stop_fn_t) spg_demo_app_stop);
  app->logger = logger;
  iot_logger_add_ref (logger);
  app->bus = bus;
  xrt_bus_add_ref (bus);
  app->pool = pool;
  iot_threadpool_add_ref (pool);
  app->write_device = (char *) iot_config_string_default (config, "WriteDevice", "", true);
  app->write_metric = (char *) iot_config_string_default (config, "WriteMetric", "", true);
  iot_config_f64 (config, "WriteValue", &app->write_value, NULL);

  xrt_spg_app_config_t app_cfg;
  xrt_spg_app_config_init (&app_cfg);
  app->app_id = (char *) iot_config_string_default (config, "AppId", app_cfg.app_id, true);
  app_cfg.app_id = app->app_id;
  app_cfg.ctx = app;
  app_cfg.callbacks.on_device_added = on_device_added;
  app_cfg.callbacks.on_metric_value_updated = on_metric_value_updated;
  if (*app->write_device)
  {
    app_cfg.callbacks.on_device_metric_added = on_device_metric_added;
  }

  app->spg_app = xrt_spg_app_new (bus, &app_cfg, NULL, pool, logger);
  if (app->spg_app == NULL)
  {
    iot_log_error (logger, "%s: failed to create sparkplug application", SPG_DEMO_APP_TYPE);
    spg_demo_app_free (app);
    return NULL;
  }
  return &app->component;
}

const iot_component_factory_t *spg_demo_app_factory (void)
{
  static iot_component_factory_t factory =
  {
    SPG_DEMO_APP_TYPE,
    IOT_CATEGORY_USER,
    spg_demo_app_config,
    (iot_component_free_fn_t) spg_demo_app_free,
    NULL,
    NULL
  };
  return &factory;
}
