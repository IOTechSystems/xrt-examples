#include <signal.h>
#include "xrt/mt3620_device.h"
#include "xrt/log_exporter.h"
#include "xrt/influxdb_exporter.h"
#include "xrt/azuresphere_exporter.h"
#include "xrt/rest_exporter.h"
#include "xrt/lua_transform.h"
#include "xrt/config_server.h"

#ifdef DEVICE_MODBUS
#include "xrt/modbus_device_service.h"
#endif
#ifdef DEVICE_BACNET
#include "xrt/bacnet_ip_device_service.h"
extern void bip_debug_enable (void);
#endif
#ifdef DEVICE_VIRTUAL
#include "xrt/virtual_device_service.h"
#endif
/* Shutdown TERM signal handling */

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

static void termination_handler (int signal)
{
  pthread_mutex_unlock (&mutex);
}

int main (void)
{
  iot_container_config_t config = { .load = iot_file_config_loader, .uri = "config", .save = NULL };

  pthread_mutex_lock (&mutex);
  struct sigaction action;
  memset (&action, 0, sizeof (struct sigaction));
  action.sa_handler = termination_handler;
  sigaction (SIGTERM, &action, NULL);

  iot_init ();
  iot_container_config (&config);
  iot_container_t * container = iot_container_alloc ("main");

  iot_component_factory_add (iot_logger_factory ());
  iot_component_factory_add (iot_threadpool_factory ());
  iot_component_factory_add (iot_scheduler_factory ());
  iot_component_factory_add (xrt_bus_factory ());
  iot_component_factory_add (xrt_log_exporter_factory ());
  iot_component_factory_add (xrt_mt3620_device_factory ());
  iot_component_factory_add (xrt_azuresphere_exporter_factory ());
  iot_component_factory_add (xrt_influxdb_exporter_factory ());
#ifdef DEVICE_MODBUS
  iot_component_factory_add (xrt_modbus_device_service_factory ());
#endif
#ifdef DEVICE_BACNET
  iot_component_factory_add (xrt_bacnet_ip_device_service_factory ());
#endif
#ifdef DEVICE_VIRTUAL
  iot_component_factory_add (xrt_virtual_device_service_factory ());
#endif

  iot_container_init (container);
  iot_container_start (container);

  pthread_mutex_lock (&mutex);

  iot_container_stop (container);
  iot_container_free (container);
  iot_fini ();
  return 0;
}
