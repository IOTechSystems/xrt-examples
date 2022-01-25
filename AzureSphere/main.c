#include <signal.h>
#include "xrt/mt3620_device.h"
#include "xrt/log_exporter.h"
#include "xrt/influxdb_exporter.h"
#include "xrt/azuresphere_exporter.h"
#include "xrt/rest_exporter.h"
#include "xrt/lua_transform.h"
#include <applibs/storage.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#ifdef DEVICE_MODBUS
#include "xrt/modbus_device_service.h"
#endif
#ifdef DEVICE_BACNET
#include "xrt/bacnet_ip_device_service.h"
extern void bip_debug_enable (void);
#endif
#ifdef DEVICE_ETHERNETIP
#include "xrt/ethernet_ip_device_service.h"
#endif
#ifdef DEVICE_VIRTUAL
#include "xrt/virtual_device_service.h"
#endif
/* Shutdown TERM signal handling */

#define MALLOC_BLOCK_SIZE 512

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static char * config = NULL;
static iot_data_t * map = NULL;

static void termination_handler (int signal)
{
  pthread_mutex_unlock (&mutex);
}

static char * read_mutable_file (void)
{
  char * buff = NULL;
  int fd = Storage_OpenMutableFile ();
  if (fd != -1)
  {
    ssize_t ret;
    char * ptr;
    size_t size = 0;
    while (true)
    {
      buff = realloc (buff, size + MALLOC_BLOCK_SIZE);
      ptr = buff + size;
      memset (ptr, 0, MALLOC_BLOCK_SIZE);
      ret = read (fd, ptr, MALLOC_BLOCK_SIZE);
      if (ret < MALLOC_BLOCK_SIZE) break;
      size += MALLOC_BLOCK_SIZE;
    }
    close (fd);
  }
  return buff;
}

static char * config_loader (const char * name, const char * uri)
{
  char * ret = NULL;

  if (!config)
  {
    config = read_mutable_file ();
    printf("config = %s\n", config);
    map = iot_data_from_json (config);
  }
  if (config)
  {
    const iot_data_t * config_props = map ? iot_data_string_map_get_map (map, "Components") : NULL;
    const iot_data_t * props = config_props ? iot_data_string_map_get_map (config_props, name) : NULL;
    if (props) ret = iot_data_to_json (props);
  }
  if (!ret) ret = iot_file_config_loader (name, uri);
  return ret;
}

static void free_load_config (void)
{
  iot_data_free (map);
  free (config);
}

int main (void)
{
  iot_container_config_t config = { .load = config_loader, .uri = "config", .save = NULL };

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
  iot_component_factory_add (xrt_mt3620_device_factory ());
  iot_component_factory_add (xrt_log_exporter_factory ());
  iot_component_factory_add (xrt_azuresphere_exporter_factory ());

#ifndef DEVICE_BACNET
  iot_component_factory_add (xrt_lua_transform_factory ());
#endif

#ifdef DEVICE_MODBUS
  iot_component_factory_add (xrt_modbus_device_service_factory ());
#endif
#ifdef DEVICE_BACNET
  iot_component_factory_add (xrt_bacnet_ip_device_service_factory ());
#endif
#ifdef DEVICE_ETHERNETIP
  iot_component_factory_add (xrt_ethernet_ip_device_service_factory ());
#endif
#ifdef DEVICE_VIRTUAL
  iot_component_factory_add (xrt_virtual_device_service_factory ());
#endif

  iot_container_init (container);
  free_load_config ();

#ifdef DEVICE_BACNET
  // bip_debug_enable ();
#endif
  iot_container_start (container);

  pthread_mutex_lock (&mutex);

  iot_container_stop (container);
  iot_container_free (container);
  iot_fini ();
  return 0;
}
