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

/* Allocation function, takes as arguments all required component attributes */
extern my_component_t * my_component_alloc (xrt_bus_t * bus, const char * request_topic, const char * reply_topic, iot_logger_t * logger)
{
  iot_log_trace (logger, "my_component_alloc()");
  my_component_t * mycomp = calloc (1, sizeof (*mycomp));
  iot_component_init (&mycomp->component, my_component_factory (), (iot_component_start_fn_t) my_component_start, (iot_component_stop_fn_t) my_component_stop);

  mycomp->logger = logger;
  iot_logger_add_ref (logger);

  mycomp->bus = bus;
  mycomp->sub = xrt_bus_sub_alloc (bus, request_topic, mycomp, XRT_BUS_NULL_COOKIE, my_component_add_callback, 0);
  xrt_bus_sub_disable (mycomp->sub);

  mycomp->pub = xrt_bus_pub_alloc (bus, reply_topic, mycomp, 0, NULL, 0);
  xrt_bus_pub_disable (mycomp->pub);  

  return mycomp;
}

/* Increment component reference count. Delegated to base component */
extern void my_component_add_ref (my_component_t * mycomp)
{
  iot_component_add_ref (&mycomp->component);
}

/* Component free function,  Only actually free if reference count is zero. */
extern void my_component_free (my_component_t * mycomp)
{
  if (mycomp && iot_component_dec_ref (&mycomp->component))
  {
    iot_log_trace (mycomp->logger, "my_component_free()");
    iot_logger_free (mycomp->logger);    
    iot_component_fini (&mycomp->component);

    xrt_bus_sub_free (mycomp->sub);
    xrt_bus_pub_free (mycomp->pub);
    xrt_bus_free (mycomp->bus);

    free (mycomp);
  }
}

/* Start component and update state */
extern void my_component_start (my_component_t * mycomp)
{
  iot_log_trace (mycomp->logger, "my_component_start()");
  iot_component_set_running (&mycomp->component);
}

/* Stop component and update state */
extern void my_component_stop (my_component_t * mycomp)
{
  iot_log_trace (mycomp->logger, "my_component_stop()");
  iot_component_set_stopped (&mycomp->component);
}

/* Component creation and configuration function, called from factory. */
static iot_component_t * my_component_config (iot_container_t * cont, const iot_data_t * map)
{
  iot_component_t * mycomp = NULL;
  iot_logger_t * logger = (iot_logger_t*) iot_container_find_component (cont, iot_data_string_map_get_string (map, "Logger"));
  xrt_bus_t * bus = (xrt_bus_t*) iot_config_component (map, "Bus", cont, logger);
  const char * request_topic = iot_config_string (map, "RequestTopic", false, logger);
  const char * reply_topic = iot_config_string (map, "ReplyTopic", false, logger);

  if (bus && request_topic && reply_topic)
  {
    mycomp = (iot_component_t *) my_component_alloc (bus, request_topic, reply_topic, logger);
//    printf("RequestTopic: %s\n", request_topic);
//    printf("ReplyTopic: %s\n", reply_topic);
  }
  return mycomp;
}

/**
 * Callback function which subscribes to the request topic
 * filters the values from the stream of Random-Device1 and Random-Device2
 * adds the random generated values from the two channels together
 * republishes the result back to the bus
 */
static void my_component_add_callback (iot_data_t * data, void * self, const char * match)
{
  // subscribe to virtual_device_service/transformed_data topic
  // filter out data.device to get the separate streams of data
  // how to access data in a topic?
  // perform add operation on the two streams
  // publish result to virtual_device_service/result

  my_component_t * mycomp = (my_component_t*) self;
  iot_log_trace (mycomp->logger, "my_component_add_callback (Pattern: %s)", match);

  //&mycomp->component
}

/* Function to return static component factory. Used by container. */
extern const iot_component_factory_t * my_component_factory (void)
{
  static iot_component_factory_t factory = { MY_COMPONENT_TYPE, my_component_config, (iot_component_free_fn_t) my_component_free, NULL , NULL};
  return &factory;
}