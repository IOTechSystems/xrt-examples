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
#define IOT_LOG_LEVELS 6

static pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
static char * config = NULL;
static iot_data_t * map = NULL;
static const char * iot_log_levels[IOT_LOG_LEVELS] = {"", "ERROR", "WARN", "Info", "Debug", "Trace"};

static void log_to_udp_broadcast (iot_logger_t * logger, iot_loglevel_t level, uint64_t timestamp, const char * message)
{
  static char str[1400];
  static const char * iot_log_levels[IOT_LOG_LEVELS] = {"", "ERROR", "WARN", "Info", "Debug", "Trace"};
  struct sockaddr_in broadcast_addr;
  int sock = socket(AF_INET, SOCK_DGRAM, 0);
  int yes = 1;
  const char * sep = strchr (logger->to, ':');
  memset((void*) &broadcast_addr, 0, sizeof(struct sockaddr_in));
  broadcast_addr.sin_family = AF_INET;
  if (sep)
  {
    char target[17];
    strncpy (target, logger->to, (size_t) (sep - logger->to));
    inet_aton (target, &broadcast_addr.sin_addr);
    broadcast_addr.sin_port = htons((uint16_t) atoi (sep + 1));
  }
  else
  {
    broadcast_addr.sin_addr.s_addr = htonl(INADDR_BROADCAST);
    broadcast_addr.sin_port = htons((uint16_t) atoi (logger->to));
  }
  iot_component_lock (&logger->component);
  int len = snprintf (str, sizeof (str), "[%" PRIu64 ":%s:%s] %s\n", timestamp, logger->name, iot_log_levels[level], message);
  if (len < 0)
  {
    perror ("snprintf error");
    goto DONE;
  }
  int ret = setsockopt(sock, SOL_SOCKET, SO_BROADCAST, (char*)&yes, sizeof(yes));
  if (ret == -1)
  {
    perror ("setsockopt error");
    goto DONE;
  }
  ret = sendto (sock, str, (size_t) len, 0, (struct sockaddr*) &broadcast_addr, sizeof (struct sockaddr_in) );
  if (ret < 0)
  {
    perror ("sendto error");
  }
  DONE:
  iot_component_unlock (&logger->component);
  close (sock);
}

static iot_loglevel_t iot_logger_config_level (const iot_data_t * map)
{
  iot_loglevel_t level = IOT_LOGLEVEL_DEFAULT;
  const char * name = iot_data_string_map_get_string (map, "Level");
  if (name)
  {
    int c = toupper (name[0]);
    for (int lvl = 0; lvl < IOT_LOG_LEVELS; lvl++)
    {
      if (iot_log_levels[lvl][0] == c)
      {
        level = lvl;
        break;
      }
    }
  }
  return level;
}

static iot_component_t * udp_logger_config (iot_container_t * cont, const iot_data_t * map)
{
  iot_logger_t * next;
  iot_logger_t * logger;
  iot_loglevel_t level = iot_logger_config_level (map);
  const char * to = iot_data_string_map_get_string (map, "To");
  next = (iot_logger_t*) iot_container_find_component (cont, iot_data_string_map_get_string (map, "Next"));
  bool self_start = iot_data_string_map_get_bool (map, "Start", true);
  printf("udp_logger_config: To = %s\n", to);
  logger = iot_logger_alloc_custom (iot_data_string_map_get_string (map, "Name"), level, to, log_to_udp_broadcast, next, self_start);
  return &logger->component;
}

static const iot_component_factory_t * udp_logger_factory (void)
{
  static iot_component_factory_t factory = { "XRT::UDPLogger", udp_logger_config, (iot_component_free_fn_t) iot_logger_free,  NULL, NULL };
  return &factory;
}

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

  iot_component_factory_add (udp_logger_factory ());
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
