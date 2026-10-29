/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Zone monitor application. XRT is linked in as a library: this runs an XRT
 * container whose components, including the zone monitor (zone_monitor.c),
 * are loaded from the config directory given on the command line.
 *
 * Usage: zone_monitor <config directory>
 */

#include <signal.h>
#include <stdio.h>
#include <unistd.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "xrt/config.h"

#include "zone_monitor.h"

static atomic_bool stopped = false;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
}

int main (int argc, char *argv[])
{
  if (argc != 2)
  {
    fprintf (stderr, "Usage: %s <config directory>\n", argv[0]);
    return 1;
  }

  /* Log lines appear straight away, even when stdout is not a terminal */
  setvbuf (stdout, NULL, _IOLBF, 0);

  struct sigaction signal_action = {0};
  signal_action.sa_handler = signal_handler;
  signal_action.sa_flags = SA_RESETHAND;
  sigaction (SIGINT, &signal_action, NULL);
  sigaction (SIGTERM, &signal_action, NULL);
  sigaction (SIGHUP, &signal_action, NULL);

  /* Load component config from <config directory>/<component>.json, as the
   * xrt executable does */
  iot_container_config_t config = {.load = iot_store_config_load, .uri = argv[1]};
  iot_container_config (&config);
  iot_container_t *container = iot_container_alloc ("main");

  /* The core factories, plus the zone monitor. XRT::Sparkplug is registered
   * by libxrt itself, and the MQTT bridge is loaded dynamically from the
   * Library/Factory named in its config. */
  iot_component_factory_add (iot_logger_factory ());
  iot_component_factory_add (iot_threadpool_factory ());
  iot_component_factory_add (iot_scheduler_factory ());
  iot_component_factory_add (xrt_bus_factory ());
  iot_component_factory_add (xrt_config_factory ());
  iot_component_factory_add (zone_monitor_factory ());

  if (!iot_container_init (container))
  {
    iot_container_free (container);
    return 1;
  }
  iot_container_start (container);

  while (!atomic_load (&stopped))
  {
    sleep (1);
  }

  iot_container_stop (container);
  iot_container_free (container);
  return 0;
}
