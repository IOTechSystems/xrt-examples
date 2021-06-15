/*
 * Copyright (c) 2021
 * IoTech Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/* Custom component boilerplate function implementations */

#include "mycomponent.h"
#include "xrt/bus.h"
//#include "iot/config.h"

/* Implementation struct, first member must be the base component type iot_component_t */
struct my_component_t
{
  iot_component_t component;       /**< Base component */
  iot_logger_t * logger;           /**< Logger (optional) */
  xrt_bus_t * bus;                 /**< Bus to which transform is connected */
  xrt_bus_sub_t * sub;             /**< Bus subscriber from which data to transform is received */
  xrt_bus_pub_t * pub;             /**< Bus publisher to which transformed data is published */
};

/** Typedef for base data my_component struct */
typedef struct my_component_t my_component_t;

extern void my_component_start (my_component_t * mycomp);
extern void my_component_stop (my_component_t * mycomp);
static void my_component_add_callback (iot_data_t * data, void * self, const char * match);
long long int my_atoi(const char *c);

/* Allocation function, takes as arguments all required component attributes */
extern my_component_t * my_component_alloc (xrt_bus_t * bus, const char * request_topic, const char * reply_topic)
{
  printf("my_component_alloc\n");
  my_component_t * mycomp = calloc (1, sizeof (*mycomp));
  iot_component_init (&mycomp->component, my_component_factory (), (iot_component_start_fn_t) my_component_start, (iot_component_stop_fn_t) my_component_stop);

  mycomp->logger = iot_logger_alloc ("MyLogger", IOT_LOG_INFO, true);
  iot_log_trace (mycomp->logger, "my_component_alloc()");

  mycomp->bus = bus;
  mycomp->sub = xrt_bus_sub_alloc (bus, request_topic, mycomp, XRT_BUS_NULL_COOKIE, my_component_add_callback, 0);
  xrt_bus_sub_disable (mycomp->sub);

  mycomp->pub = xrt_bus_pub_alloc (bus, reply_topic, mycomp, 0, NULL, 0);
  xrt_bus_pub_disable (mycomp->pub);

  return mycomp;
}

/* Component free function,  Only actually free if reference count is zero. */
extern void my_component_free (my_component_t * mycomp)
{
  if (mycomp && iot_component_dec_ref (&mycomp->component))
  {
    iot_log_trace (mycomp->logger, "my_component_free()");
    iot_logger_free (mycomp->logger);    

    xrt_bus_sub_free (mycomp->sub);
    xrt_bus_pub_free (mycomp->pub);
    xrt_bus_free (mycomp->bus);
    iot_component_fini (&mycomp->component);

    free (mycomp);
  }
}

/* Start component and update state */
extern void my_component_start (my_component_t * mycomp)
{
  printf("my_component_start\n");
  iot_log_trace (mycomp->logger, "my_component_start()");
  iot_component_set_running (&mycomp->component);

  xrt_bus_sub_enable (mycomp->sub);
  xrt_bus_pub_enable (mycomp->pub);
}

/* Stop component and update state */
extern void my_component_stop (my_component_t * mycomp)
{
  iot_log_trace (mycomp->logger, "my_component_stop()");
  iot_component_set_stopped (&mycomp->component);

  xrt_bus_sub_disable (mycomp->sub);
  xrt_bus_pub_disable (mycomp->pub);
}

/* Component creation and configuration function, called from factory. */
static iot_component_t * my_component_config (iot_container_t * cont, const iot_data_t * map)
{
  printf("my_component_config\n");
  iot_component_t * mycomp = NULL;
  iot_logger_t * logger = (iot_logger_t*) iot_container_find_component (cont, iot_data_string_map_get_string (map, "Logger"));
  xrt_bus_t * bus = (xrt_bus_t*) iot_config_component (map, "Bus", cont, logger);
  const char * request_topic = iot_config_string (map, "RequestTopic", false, logger);
  const char * reply_topic = iot_config_string (map, "ReplyTopic", false, logger);

  if (bus && request_topic && reply_topic)
  {
    mycomp = (iot_component_t *) my_component_alloc (bus, request_topic, reply_topic);
  }
  return mycomp;
}

/**
 * Callback function which subscribes to the request topic stream
 * filters the values from the readings of Random-Device1 and Random-Device2
 * adds the random generated values from the two channels together
 * re-publishes the result back to the bus
 */
static void my_component_add_callback (iot_data_t * data, void * self, const char * match)
{
  my_component_t * mycomp = (my_component_t*) self;
  iot_log_trace (mycomp->logger, "my_component_add_callback (Pattern: %s)", match);

  // filter out the devices and their corresponding values from the RequestTopic data stream
  const iot_data_t * device = iot_data_string_map_get (data, "device");
  const iot_data_t * device_data = iot_data_string_map_get (iot_data_string_map_get (iot_data_string_map_get (data, "readings"), "RandomInt8"), "value");

  char * json_device = iot_data_to_json (device);
  char * json_device_data = iot_data_to_json (device_data);
  char * device1_name = "\"Random-Device1\"";
  char * device2_name = "\"Random-Device2\"";

  int64_t device1_value = 0;
  int64_t device2_value = 0;
  static int64_t sum = 0;

  if (strcmp(json_device, device1_name) == 0)
  {
    iot_log_info (mycomp->logger, "---Device: %s", json_device);
    iot_log_info (mycomp->logger, "---Device_data: %s", json_device_data);
    device1_value = iot_data_i64(device_data);
  }
  else if (strcmp(json_device, device2_name) == 0)
  {
    iot_log_info (mycomp->logger, "---Device: %s", json_device);
    iot_log_info (mycomp->logger, "---Device_data: %s", json_device_data);
    device2_value = iot_data_i64(device_data);
  }
  else
  {
    iot_log_info (mycomp->logger, "No such device");
  }

  sum += device1_value + device2_value;
//  printf("\ndev1: %ld, dev2: %ld, sum: %ld\n", device1_value, device2_value, sum);

  // data has to be iot_data_t * type
  iot_data_t * result = iot_data_alloc_i64(sum);
  xrt_bus_pub_push(mycomp->pub, result, true);
}

/* Function to return static component factory. Used by container. */
extern const iot_component_factory_t * my_component_factory (void)
{
  static iot_component_factory_t factory = { MY_COMPONENT_TYPE, my_component_config, (iot_component_free_fn_t) my_component_free, NULL , NULL};
  return &factory;
}