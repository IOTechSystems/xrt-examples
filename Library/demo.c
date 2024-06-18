/*
 * Copyright (c) 2024
 * IOTech Ltd
 */

#include <signal.h>
#include "iot/iot.h"
#include "xrt/bus.h"
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "defines.h"

#define TIMEOUT 100
#define LOOP_DELAY 5
#define CLIENT_ID "xrt_demo"
#define PUB_TOPIC "xrt/devices/virtual/request"
#define SUB_TOPIC "xrt/devices/virtual/reply"

static pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static atomic_bool stopped = ATOMIC_VAR_INIT (false);

uint32_t xrt_exit_delay = 0u;

iot_data_t *returned = NULL;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
  pthread_cond_signal (&cond);
}

static inline iot_container_t
*

init_xrt (char *config_uri)
{
  struct sigaction signal_action = {0};
  signal_action.sa_handler = signal_handler;
  signal_action.sa_flags = SA_RESETHAND;
  sigaction (SIGINT, &signal_action, NULL);
  sigaction (SIGTERM, &signal_action, NULL);
  sigaction (SIGHUP, &signal_action, NULL);

  if (!config_uri)
  { return NULL; }
  iot_container_config_t config = {.load = iot_store_config_load, .uri = config_uri, .save = iot_store_config_save};

  iot_container_config (&config);
  iot_container_t * container = iot_container_alloc ("main");

  iot_component_factory_add (iot_logger_factory ());
  iot_component_factory_add (iot_threadpool_factory ());
  iot_component_factory_add (iot_scheduler_factory ());
  iot_component_factory_add (xrt_bus_factory ());
  iot_component_factory_add (xrt_config_factory ());

  iot_container_init (container);

  return container;
}


static inline void start_xrt (iot_container_t *container)
{
  iot_container_start (container);
}

static inline void stop_xrt (iot_container_t *container)
{
  iot_container_stop (container);
}

static inline void free_xrt (iot_container_t *container)
{
  iot_container_free (container);
}

typedef struct
{
  iot_logger_t *logger;      /**< Logger (optional) */
  xrt_bus_t *bus;            /**< Bus to which app_component is connected to */
  xrt_bus_sub_t *sub;        /**< Bus subscriber which data to app_component is received from */
  xrt_bus_pub_t *pub;        /**< Bus publisher to which app_component data is published to */
} bus_component_t;

static void bus_component_callback (const iot_data_t *data, void *self, const char *match)
{
  returned = iot_data_copy (data);
}

/* Start component and update state */
extern void start_bus (struct bus_component_t *bus_comp)
{
  iot_log_trace (bus_comp->logger, "bus_component_start()");
  xrt_bus_sub_enable (bus_comp->sub);
  xrt_bus_pub_enable (bus_comp->pub);
}

/* Stop component and update state */
extern void stop_bus (struct bus_component_t *bus_comp)
{
  iot_log_trace (bus_comp->logger, "bus_component_stop()");
  xrt_bus_sub_disable (bus_comp->sub);
  xrt_bus_pub_disable (bus_comp->pub);
}

static struct bus_component_t *init_bus (iot_container_t *container, char *request_topic, char *reply_topic)
{
  struct bus_component_t *bus_comp = calloc (1, sizeof (*bus_comp));
  bus_comp->logger = (iot_logger_t *) iot_container_find_component (container, "logger");
  iot_logger_add_ref (bus_comp->logger);
  bus_comp->bus = (xrt_bus_t *) iot_container_find_component (container, "bus");
  xrt_bus_add_ref (bus_comp->bus);
  bus_comp->sub = xrt_bus_sub_alloc (bus_comp->bus, reply_topic, bus_comp, XRT_BUS_NULL_COOKIE, bus_component_callback, 0u, false);
  bus_comp->pub = xrt_bus_pub_alloc (bus_comp->bus, request_topic, bus_comp, 0, NULL, 0u, false);

  return bus_comp;
}

static iot_data_t *create_list_message ()
{
  iot_data_t *map = iot_data_alloc_map (IOT_DATA_STRING);
  iot_data_string_map_add (map, CLIENT_KEY, iot_data_alloc_string (CLIENT_ID, IOT_DATA_REF));
  iot_data_string_map_add (map, REQUEST_ID_KEY, iot_data_alloc_uuid_string ());
  iot_data_string_map_add (map, OP_KEY, iot_data_alloc_string (DEVICE_OP_LIST, IOT_DATA_REF));
  iot_data_string_map_add (map, TYPE_KEY, iot_data_alloc_string (XRT_REQUEST_10, IOT_DATA_REF));
  return map;
}

static iot_data_t *create_get_message (iot_data_t *device)
{
  iot_data_t *map = iot_data_alloc_map (IOT_DATA_STRING);
  iot_data_string_map_add (map, CLIENT_KEY, iot_data_alloc_string (CLIENT_ID, IOT_DATA_REF));
  iot_data_string_map_add (map, REQUEST_ID_KEY, iot_data_alloc_uuid_string ());
  iot_data_string_map_add (map, OP_KEY, iot_data_alloc_string (DEVICE_OP_GET, IOT_DATA_REF));
  iot_data_string_map_add (map, TYPE_KEY, iot_data_alloc_string (XRT_REQUEST_10, IOT_DATA_REF));
  iot_data_string_map_add (map, DEVICE_KEY, iot_data_add_ref (device));
  iot_data_string_map_add (map, RESOURCE_KEY, iot_data_alloc_string (DEVICE_RESOURCE, IOT_DATA_REF));
  return map;
}

static const iot_data_t *get_device_list (iot_data_t *response)
{
  return iot_data_add_ref (iot_data_string_map_get_list (iot_data_string_map_get (response, RESULT_KEY), DEVICES_KEY));
}

bool wait_for_reply (int timeout_ms)
{
  int elapsed_time = 0;
  while (returned && elapsed_time < timeout_ms)
  {
    // Sleep for a short interval
    usleep (1000);  // Sleep for 1 milliseconds
    elapsed_time += 1;
  }
  return returned;
}

int main ()
{
  // Initialise/start XRT and connection to it's bus
  iot_container_t * container = init_xrt (getenv ("XRT_CONFIG_DIR"));
  if (container == NULL)
  {
    return 1;
  }
  struct bus_component_t *bus = init_bus (container, PUB_TOPIC, SUB_TOPIC);
  start_xrt (container);
  start_bus (bus);

  // Control loop
  while (!atomic_load (&stopped))
  {
    iot_data_t *data = create_list_message ();
    iot_log_info (bus->logger, "request sent: %s", iot_data_to_json (data));
    xrt_bus_pub_push (bus->pub, data, true); // list message gets freed on publish
    if (wait_for_reply (TIMEOUT))
    {
      iot_log_info (bus->logger, "received reply: %s", iot_data_to_json (returned));
      const iot_data_t *result = iot_data_string_map_get (returned, RESULT_KEY);
      const iot_data_t *device_list = iot_data_add_ref (iot_data_string_map_get (result, DEVICES_KEY));
      iot_data_vector_iter_t iter;
      iot_data_vector_iter (device_list, &iter);
      while (iot_data_vector_iter_next (&iter))
      {
        const iot_data_t *ele_data = iot_data_vector_iter_value (&iter);
        const iot_data_t *device_get = create_get_message (ele_data);
        iot_log_info (bus->logger, "request sent: %s %d", iot_data_to_json (device_get), iot_data_type (device_get));
        xrt_bus_pub_push (bus->pub, iot_data_add_ref (data), true); // list message gets freed on publish

        if (wait_for_reply (TIMEOUT))
        {
          iot_log_info (bus->logger, "received reply: %s", iot_data_to_json (returned));
        }
        else
        {
          iot_log_error (bus->logger, "did not receive reply");
        }
        sleep (LOOP_DELAY);
      }
    }
    else
    {
      iot_log_error (bus->logger, "did not receive reply");
    }
    iot_data_free (returned);
  }
  stop_bus (bus);
  stop_xrt (container);
  free_xrt (container);
  return 0;
}