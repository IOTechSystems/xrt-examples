/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Zone monitor - see zone_monitor.h.
 *
 * Config:
 *   Logger, Bus, ThreadPool  Components to use (required)
 *   Node                     Sparkplug edge node publishing the zone (required)
 *   Device                   Sparkplug device of the zone (required)
 *   MaxTemperatureOffset     Degrees C above the setpoint at which the fan is
 *                            switched on. Default: 1.0
 *   SparkplugConfig          Sparkplug application settings (BIRTH cache,
 *                            preload, static mode, rebirths, ...)
 *
 * The Sparkplug application id is the XRT::Config NodeId, and the namespace,
 * group and MQTT bridge app ids come from the XRT::Sparkplug component, via
 * xrt_spg_app_config_init.
 */

#include <stdlib.h>
#include <string.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "sparkplug/sparkplug_app.h"

#include "zone_monitor.h"

#define TEMPERATURE_METRIC "zone-temperature:present-value"
#define SETPOINT_METRIC "zone-setpoint:present-value"
#define FAN_METRIC "fan-command:present-value"

typedef struct zone_monitor_t
{
  iot_component_t component;
  iot_logger_t *logger;
  iot_threadpool_t *pool;
  xrt_bus_t *bus;
  xrt_spg_app_t *spg_app;
  char *node;
  char *device;
  double max_offset;
  pthread_mutex_t lock;
  bool have_temperature;
  bool have_setpoint;
  bool have_fan;
  double temperature;
  double setpoint;
  bool fan_on;
} zone_monitor_t;

/* Sends a DCMD to switch the fan on. Runs as a thread pool job, so that the
 * lookup and command don't run inside on_metric_value_updated: up to Xrt 3.4.6
 * the Sparkplug application runs that callback while holding the node's lock,
 * which xrt_spg_app_node_get_device also takes, so looking up the fan's device
 * from inside the callback deadlocks (XRT-4202). */
static void *zone_monitor_fan_on (void *arg)
{
  zone_monitor_t *zm = arg;
  xrt_spg_app_node_t *node = xrt_spg_app_get_node (zm->spg_app, zm->node);
  xrt_spg_app_device_t *device = node ? xrt_spg_app_node_get_device (node, zm->device) : NULL;
  xrt_spg_app_metric_t *metric = device ? xrt_spg_app_device_get_metric (device, FAN_METRIC) : NULL;
  devsdk_quality_t quality = DEVSDK_QUALITY_BAD;
  if (metric)
  {
    /* The command is not sent if the fan's value is stale (DEVSDK_QUALITY_UNCERTAIN_LAST_VALUE) */
    quality = xrt_spg_app_device_send_cmd (device, metric, iot_data_alloc_ui32 (1u));
  }
  if (quality == DEVSDK_QUALITY_GOOD)
  {
    iot_log_info (zm->logger, "switching fan on");
  }
  else
  {
    iot_log_warn (zm->logger, "could not switch fan on (quality %d), will retry on the next update", (int) quality);
    pthread_mutex_lock (&zm->lock);
    zm->fan_on = false;
    pthread_mutex_unlock (&zm->lock);
  }
  xrt_spg_app_metric_free (metric);
  xrt_spg_app_device_free (device);
  xrt_spg_app_node_free (node);
  return NULL;
}

/* Records a new value of one of the zone's metrics. Returns true if the fan
 * needs switching on. */
static bool zone_monitor_update (zone_monitor_t *zm, const char *name, const iot_data_t *value)
{
  double val;
  bool switch_fan_on = false;

  if (value == NULL || !iot_data_cast (value, IOT_DATA_FLOAT64, &val)) return false;

  pthread_mutex_lock (&zm->lock);
  if (strcmp (name, TEMPERATURE_METRIC) == 0)
  {
    zm->temperature = val;
    zm->have_temperature = true;
    iot_log_info (zm->logger, "zone temperature %.2f C", val);
  }
  else if (strcmp (name, SETPOINT_METRIC) == 0)
  {
    zm->setpoint = val;
    zm->have_setpoint = true;
    iot_log_info (zm->logger, "zone setpoint %.2f C", val);
  }
  else if (strcmp (name, FAN_METRIC) == 0)
  {
    zm->fan_on = (val != 0.0);
    zm->have_fan = true;
    iot_log_info (zm->logger, "fan %s", zm->fan_on ? "on" : "off");
  }
  if (zm->have_temperature && zm->have_setpoint && zm->have_fan && !zm->fan_on && zm->temperature > zm->setpoint + zm->max_offset)
  {
    iot_log_info (zm->logger, "zone is %.2f C above setpoint with the fan off", zm->temperature - zm->setpoint);
    zm->fan_on = true; /* Don't send the command again before the new value is published */
    switch_fan_on = true;
  }
  pthread_mutex_unlock (&zm->lock);
  return switch_fan_on;
}

/* Fired for every metric value change in a DATA message, or when a metric goes
 * stale. The metric is locked by the Sparkplug application for the duration. */
static void on_metric_value_updated (xrt_spg_app_metric_t *metric, void *app_ctx)
{
  zone_monitor_t *zm = app_ctx;
  if (xrt_spg_app_metric_is_stale (metric))
  {
    iot_log_info (zm->logger, "'%s' is stale", xrt_spg_app_metric_name (metric));
    return;
  }
  if (zone_monitor_update (zm, xrt_spg_app_metric_name (metric), xrt_spg_app_metric_get_value (metric)))
  {
    iot_threadpool_add_work (zm->pool, zone_monitor_fan_on, zm, -1);
  }
}

/* Fired once a device's metrics have been set from its BIRTH, whether the BIRTH
 * came from a DBIRTH message, the BIRTH cache or a preloaded BIRTH record.
 * Takes the zone's current values from it. */
static void on_device_metrics_update_finish (xrt_spg_app_node_t *node, void *app_ctx, xrt_spg_app_device_t *device)
{
  zone_monitor_t *zm = app_ctx;
  static const char *metrics[] = { SETPOINT_METRIC, FAN_METRIC, TEMPERATURE_METRIC };
  bool switch_fan_on = false;

  if (strcmp (xrt_spg_app_node_get_id (node), zm->node) != 0 || strcmp (xrt_spg_app_device_name (device), zm->device) != 0) return;

  for (size_t i = 0; i < sizeof (metrics) / sizeof (metrics[0]); i++)
  {
    xrt_spg_app_metric_t *metric = xrt_spg_app_device_get_metric (device, metrics[i]);
    if (metric == NULL)
    {
      /* Not in the BIRTH, or the device is being removed */
      iot_log_debug (zm->logger, "device '%s' has no metric '%s'", zm->device, metrics[i]);
      continue;
    }
    /* Values from a BIRTH cache or a preloaded BIRTH record are stale until
     * the device publishes them again */
    xrt_spg_app_metric_lock (metric);
    if (xrt_spg_app_metric_is_stale (metric))
    {
      iot_log_info (zm->logger, "waiting for a current value of '%s'", metrics[i]);
    }
    else
    {
      switch_fan_on |= zone_monitor_update (zm, metrics[i], xrt_spg_app_metric_get_value (metric));
    }
    xrt_spg_app_metric_unlock (metric);
    xrt_spg_app_metric_free (metric);
  }
  if (switch_fan_on) iot_threadpool_add_work (zm->pool, zone_monitor_fan_on, zm, -1);
}

static void on_node_added (xrt_spg_app_t *app, void *app_ctx, xrt_spg_app_node_t *node)
{
  (void) app;
  zone_monitor_t *zm = app_ctx;
  iot_log_info (zm->logger, "node '%s' added", xrt_spg_app_node_get_id (node));
}

static void on_device_added (xrt_spg_app_node_t *node, void *app_ctx, xrt_spg_app_device_t *device)
{
  zone_monitor_t *zm = app_ctx;
  iot_log_info (zm->logger, "device '%s' added on node '%s'", xrt_spg_app_device_name (device), xrt_spg_app_node_get_id (node));
}

static void on_device_removed (xrt_spg_app_node_t *node, void *app_ctx, xrt_spg_app_device_t *device)
{
  zone_monitor_t *zm = app_ctx;
  iot_log_info (zm->logger, "device '%s' removed from node '%s'", xrt_spg_app_device_name (device), xrt_spg_app_node_get_id (node));
}

static void zone_monitor_start (zone_monitor_t *zm)
{
  if (!iot_component_set_running (&zm->component)) return;
  if (!xrt_spg_app_start (zm->spg_app))
  {
    iot_log_error (zm->logger, "%s: failed to start sparkplug application", ZONE_MONITOR_TYPE);
  }
}

static void zone_monitor_stop (zone_monitor_t *zm)
{
  if (!iot_component_set_stopped (&zm->component)) return;
  xrt_spg_app_stop (zm->spg_app);
}

static void zone_monitor_free (zone_monitor_t *zm)
{
  xrt_spg_app_free (zm->spg_app);
  xrt_bus_free (zm->bus);
  iot_threadpool_free (zm->pool);
  iot_logger_free (zm->logger);
  free (zm->node);
  free (zm->device);
  pthread_mutex_destroy (&zm->lock);
  iot_component_fini (&zm->component);
  free (zm);
}

static iot_component_t *zone_monitor_config (iot_container_t *container, const iot_data_t *config)
{
  iot_logger_t *logger = (iot_logger_t *) iot_config_component (config, "Logger", container, NULL);
  xrt_bus_t *bus = (xrt_bus_t *) iot_config_component (config, "Bus", container, logger);
  iot_threadpool_t *pool = (iot_threadpool_t *) iot_config_component (config, "ThreadPool", container, logger);
  const char *node = iot_data_string_map_get_string (config, "Node");
  const char *device = iot_data_string_map_get_string (config, "Device");
  if (bus == NULL || pool == NULL || node == NULL || device == NULL)
  {
    iot_log_error (logger, "%s: Bus, ThreadPool, Node and Device must be configured", ZONE_MONITOR_TYPE);
    return NULL;
  }

  xrt_spg_app_config_t app_cfg;
  xrt_spg_app_config_init (&app_cfg);

  /* The Sparkplug application settings: how the application learns about the
   * nodes and devices it is monitoring (BIRTH messages, BIRTH cache or
   * preloaded BIRTH records), and whether it asks them to rebirth. */
  const iot_data_t *spg_config = iot_data_string_map_get_map (config, "SparkplugConfig");
  if (spg_config)
  {
    if (!xrt_spg_app_config_settings_init_from_iot (&app_cfg.settings, spg_config, logger))
    {
      iot_log_error (logger, "%s: invalid SparkplugConfig", ZONE_MONITOR_TYPE);
      return NULL;
    }
    /* StaticMode is not read by xrt_spg_app_config_settings_init_from_iot
     * (XRT-4201), so set it here. */
    app_cfg.settings.static_mode = iot_data_string_map_get_bool (spg_config, "StaticMode", false);
  }

  zone_monitor_t *zm = calloc (1, sizeof (*zm));
  iot_component_init (&zm->component, zone_monitor_factory (), (iot_component_start_fn_t) zone_monitor_start, (iot_component_stop_fn_t) zone_monitor_stop);
  pthread_mutex_init (&zm->lock, NULL);
  zm->logger = logger;
  iot_logger_add_ref (logger);
  zm->bus = bus;
  xrt_bus_add_ref (bus);
  zm->pool = pool;
  iot_threadpool_add_ref (pool);
  zm->node = strdup (node);
  zm->device = strdup (device);
  zm->max_offset = iot_data_string_map_get_f64 (config, "MaxTemperatureOffset", 1.0);

  app_cfg.ctx = zm;
  app_cfg.callbacks.on_node_added = on_node_added;
  app_cfg.callbacks.on_device_added = on_device_added;
  app_cfg.callbacks.on_device_removed = on_device_removed;
  app_cfg.callbacks.on_device_metrics_update_finish = on_device_metrics_update_finish;
  app_cfg.callbacks.on_metric_value_updated = on_metric_value_updated;

  iot_log_info (logger, "%s: app '%s' monitoring '%s/%s'%s%s%s", ZONE_MONITOR_TYPE, app_cfg.app_id, zm->node, zm->device,
    app_cfg.settings.birth_cache_dir ? ", BIRTH cache enabled" : "",
    app_cfg.settings.static_mode ? ", static mode" : "",
    app_cfg.settings.issue_node_rebirths || app_cfg.settings.issue_device_rebirths ? ", issues rebirths" : "");

  zm->spg_app = xrt_spg_app_new (bus, &app_cfg, NULL, pool, logger);
  if (zm->spg_app == NULL)
  {
    iot_log_error (logger, "%s: failed to create sparkplug application", ZONE_MONITOR_TYPE);
    zone_monitor_free (zm);
    return NULL;
  }
  return &zm->component;
}

const iot_component_factory_t *zone_monitor_factory (void)
{
  static iot_component_factory_t factory =
  {
    ZONE_MONITOR_TYPE,
    IOT_CATEGORY_USER,
    zone_monitor_config,
    (iot_component_free_fn_t) zone_monitor_free,
    NULL,
    NULL
  };
  return &factory;
}
