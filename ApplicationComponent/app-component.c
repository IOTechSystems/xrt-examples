/*
 * Copyright (c) 2023
 * IoTech Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/* Custom application component function implementations */
#define DEVICE1_NAME "\"Random-Device1\""
#define DEVICE2_NAME "\"Random-Device2\""

#include "app-component.h"

/* Implementation struct, first member must be the base component type iot_component_t */
struct app_component_t
{
  iot_component_t component; /**< Base application component */
  iot_logger_t *logger;      /**< Logger (optional) */
  xrt_bus_t *bus;            /**< Bus to which app_component is connected to */
  xrt_bus_sub_t *sub;        /**< Bus subscriber which data to app_component is received from */
  xrt_bus_pub_t *pub;        /**< Bus publisher to which app_component data is published to */
};

/** Typedef for base data app_component struct */
typedef struct app_component_t app_component_t;

extern void app_component_start (app_component_t *app_comp);

extern void app_component_stop (app_component_t *app_comp);

static void app_component_add_callback (const iot_data_t *data, void *self, const char *match);

/* Allocation function, takes as arguments all required component attributes */
extern app_component_t *app_component_alloc (xrt_bus_t *bus, const char *request_topic, const char *reply_topic, iot_logger_t *logger)
{
  app_component_t *app_comp = calloc (1, sizeof (*app_comp));
  app_comp->logger = logger;
  iot_log_trace (app_comp->logger, "app_component_alloc()");
  iot_component_init (&app_comp->component, app_component_factory (), (iot_component_start_fn_t) app_component_start,
                      (iot_component_stop_fn_t) app_component_stop);
  app_comp->bus = bus;
  app_comp->sub = xrt_bus_sub_alloc (bus, request_topic, app_comp, XRT_BUS_NULL_COOKIE, app_component_add_callback, 0u, false);
  app_comp->pub = xrt_bus_pub_alloc (bus, reply_topic, app_comp, 0, NULL, 0u, false);

  return app_comp;
}

/* Component free function,  Only actually free if reference count is zero. */
extern void app_component_free (app_component_t *app_comp)
{
  iot_log_trace (app_comp->logger, "app_component_free()");
  iot_logger_free (app_comp->logger);
  xrt_bus_free (app_comp->bus);
  xrt_bus_sub_free (app_comp->sub);
  xrt_bus_pub_free (app_comp->pub);

  iot_component_fini (&app_comp->component);
  free (app_comp);
}

/* Start component and update state */
extern void app_component_start (app_component_t *app_comp)
{
  iot_log_trace (app_comp->logger, "app_component_start()");
  iot_component_set_running (&app_comp->component);
  xrt_bus_sub_enable (app_comp->sub);
  xrt_bus_pub_enable (app_comp->pub);
}

/* Stop component and update state */
extern void app_component_stop (app_component_t *app_comp)
{
  iot_log_trace (app_comp->logger, "app_component_stop()");
  iot_component_set_stopped (&app_comp->component);
  xrt_bus_sub_disable (app_comp->sub);
  xrt_bus_pub_disable (app_comp->pub);
}

/* Component creation and configuration function, called from factory. */
static iot_component_t *app_component_config (iot_container_t *cont, const iot_data_t *map)
{
  iot_component_t *app_comp = NULL;
  iot_logger_t *logger = (iot_logger_t *) iot_container_find_component (cont, iot_data_string_map_get_string (map, "Logger"));
  xrt_bus_t *bus = (xrt_bus_t *) iot_config_component (map, "Bus", cont, logger);
  const char *request_topic = iot_config_string (map, "RequestTopic", false, logger);
  const char *reply_topic = iot_config_string (map, "ReplyTopic", false, logger);

  if (bus && request_topic && reply_topic)
  {
    app_comp = (iot_component_t *) app_component_alloc (bus, request_topic, reply_topic, logger);
    iot_log_trace (logger, "app_component_config()");
  }
  return app_comp;
}

/**
 * Callback function which subscribes to the request topic stream
 * filters the values from the readings of Random-Device1 and Random-Device2
 * adds the random generated values from the two channels together
 * re-publishes the result back to the bus
 */
static void app_component_add_callback (const iot_data_t *data, void *self, const char *match)
{
  app_component_t *app_comp = (app_component_t *) self;
  iot_log_trace (app_comp->logger, "app_component_add_callback");

  // filter out the devices and their corresponding values from the RequestTopic data stream
  const iot_data_t *device = iot_data_string_map_get (data, "device");
  const iot_data_t *device_data = iot_data_string_map_get (iot_data_string_map_get (data, "lua"), "transformed_data");

  char *json_device = iot_data_to_json (device);
  char *json_device_data = iot_data_to_json (device_data);

  static int64_t device1_value = 0;
  static int64_t device2_value = 0;
  int64_t sum = 0;

  if (strcmp (json_device, DEVICE1_NAME) == 0)
  {
    iot_log_info (app_comp->logger, "---Device: %s", json_device);
    iot_log_info (app_comp->logger, "---Device_data: %s", json_device_data);
    device1_value = iot_data_i64 (device_data);
  }
  else if (strcmp (json_device, DEVICE2_NAME) == 0)
  {
    iot_log_info (app_comp->logger, "---Device: %s", json_device);
    iot_log_info (app_comp->logger, "---Device_data: %s", json_device_data);
    device2_value = iot_data_i64 (device_data);
  }
  else
  {
    iot_log_info (app_comp->logger, "No such device");
  }

  sum = device1_value + device2_value;
  iot_log_info (app_comp->logger, "---sum: %d", sum);

  // data has to be put back to the map and will be published on the reply topic specified in the json config
  iot_data_t *map = iot_data_alloc_map (IOT_DATA_STRING);
  iot_data_string_map_add (map, "Result", iot_data_alloc_i64 (sum));
  xrt_bus_pub_push (app_comp->pub, map, true);// publish takes ownership over map, free will be taken care of
  free (json_device);
  free (json_device_data);
}

/* Function to return static component factory. Used by Container. */
extern const iot_component_factory_t *app_component_factory (void)
{
  static iot_component_factory_t factory =
    {
      APP_COMPONENT_TYPE,
      XRT_CATEGORY_TRANSFORM,
      app_component_config,
      (iot_component_free_fn_t) app_component_free,
      NULL,
      NULL
    };
  return &factory;
}
