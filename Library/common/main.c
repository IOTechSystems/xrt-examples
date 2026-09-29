/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * XRT linked in as a library. All this does is run an XRT container whose
 * config is compiled in from the app's own deployment_config.h. The app's
 * behaviour lives in components loaded by that config, such as the demo
 * Sparkplug application (spg_demo_app.c).
 */

#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "iot/iot.h"
#include "xrt/bus.h"
#include "xrt/config.h"
#include "xrt/sparkplug.h"

#include "spg_demo_app.h"
#include "deployment_config.h"

static atomic_bool stopped = false;

/*
 * XRT::SparkplugNode (libxrt-sparkplug.so) references `xrt_exit_delay` as
 * extern, but it is only defined in xrt.c, which is compiled into the
 * standalone `xrt` executable rather than into any library. A colocated
 * host process that loads a Sparkplug node must provide it itself, or
 * loading libxrt-sparkplug.so fails with "undefined symbol: xrt_exit_delay".
 * Requires linking with -rdynamic so libxrt-sparkplug.so can resolve it back
 * from this executable's own symbol table.
 */
atomic_uint_fast64_t xrt_exit_delay = 0u;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
}

/* Component config is compiled in (deployment_config.h) rather than read
 * from a config directory, so look it up by component id. */
static char *config_loader (const char *name, const char *uri)
{
  (void) uri;
  for (size_t i = 0; i < sizeof (app_configs) / sizeof (app_configs[0]); i++)
  {
    if (strcmp (name, app_configs[i].id) == 0)
    {
      return strdup (app_configs[i].config);
    }
  }
  return NULL;
}

int main (void)
{
  struct sigaction signal_action = {0};
  signal_action.sa_handler = signal_handler;
  signal_action.sa_flags = SA_RESETHAND;
  sigaction (SIGINT, &signal_action, NULL);
  sigaction (SIGTERM, &signal_action, NULL);
  sigaction (SIGHUP, &signal_action, NULL);

  iot_container_config_t config = {.load = config_loader};
  iot_container_config (&config);
  iot_container_t *container = iot_container_alloc ("main");

  /* Everything else (MQTT bridge, Sparkplug node, device services) is
   * loaded dynamically from the Library/Factory named in its config. */
  iot_component_factory_add (iot_logger_factory ());
  iot_component_factory_add (iot_threadpool_factory ());
  iot_component_factory_add (iot_scheduler_factory ());
  iot_component_factory_add (xrt_bus_factory ());
  iot_component_factory_add (xrt_config_factory ());
  iot_component_factory_add (xrt_sparkplug_config_factory ());
  iot_component_factory_add (spg_demo_app_factory ());

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
