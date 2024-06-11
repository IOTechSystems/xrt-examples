#include <signal.h>
#include <atomic>
#include <chrono>
#include <thread>
#include <string>
#include "iot/iot.h"
#include "xrt/bus.h"
#include "defines.h"

#define CLIENT_ID "xrt_demo"
#define PUB_TOPIC "xrt/devices/virtual/request"
#define SUB_TOPIC "xrt/devices/virtual/reply"


class XRT {
private:
  iot_container_t* container;

public:
  XRT (const std::string& config_uri) {
    struct sigaction signal_action = {0};
    memset (&signal_action, 0, sizeof (signal_action));
    signal_action.sa_handler = XRT::signalHandler;
    signal_action.sa_flags = SA_RESETHAND;
    sigaction (SIGINT, &signal_action, NULL);
    sigaction (SIGTERM, &signal_action, NULL);
    sigaction (SIGHUP, &signal_action, NULL);
  
    iot_container_config_t config;
    config.load = iot_store_config_load;
    config.uri = config_uri.c_str();
    config.save = iot_store_config_save;
  
    iot_container_config (&config);
    container = iot_container_alloc ("main");
  
    iot_component_factory_add (iot_logger_factory());
    iot_component_factory_add (iot_threadpool_factory());
    iot_component_factory_add (iot_scheduler_factory());
    iot_component_factory_add (xrt_bus_factory());
    iot_component_factory_add (xrt_config_factory());
  
    iot_container_init (container);
  }

  ~XRT() {
    iot_container_free (container);
  }

  void start() {
    iot_container_start (container);
  }

  void stop() {
    iot_container_stop (container);
  }

  iot_container_t* getContainer() {
    return container;
  }

  static void signalHandler (int sig) {
    (void)sig;
    atomic_store (&stopped, true);
  }

  static std::atomic<bool> stopped;
};

std::atomic<bool> XRT::stopped = ATOMIC_VAR_INIT(false);

class BUS {
private:
  iot_logger_t* logger;
  xrt_bus_t* bus;
  xrt_bus_sub_t* sub;
  xrt_bus_pub_t* pub;
  iot_data_t* returned;

  static void busComponentCallback (const iot_data_t* data, void* self, const char* match)
  {
    BUS* bus = static_cast <BUS*> (self);
    bus->returned = iot_data_copy (data);
  }

public:
  BUS (iot_container_t* container, const std::string& request_topic, const std::string& reply_topic)
  {
    logger = (iot_logger_t*) iot_container_find_component (container, "logger");
    if (logger)
    {
      iot_logger_add_ref (logger);
      iot_log_trace (logger, "bus_component_init");
    }
    bus = (xrt_bus_t*) iot_container_find_component (container, "bus");
    xrt_bus_add_ref (bus);
    sub = xrt_bus_sub_alloc (bus, reply_topic.c_str(), this, XRT_BUS_NULL_COOKIE, BUS::busComponentCallback, 0u, false);
    pub = xrt_bus_pub_alloc (bus, request_topic.c_str(), this, 0, NULL, 0u, false);
    returned = NULL;
  }

  ~BUS()
  {
    xrt_bus_sub_free (sub);
    xrt_bus_pub_free (pub);
    iot_data_free (returned);
  }

  void start()
  {
    iot_log_trace (logger, "bus_component_start");
    xrt_bus_sub_enable (sub);
    xrt_bus_pub_enable (pub);
  }

  void stop()
  {
    iot_log_trace (logger, "bus_component_stop");
    xrt_bus_sub_disable (sub);
    xrt_bus_pub_disable (pub);
  }

  iot_data_t* createListMessage()
  {
    iot_data_t * map = iot_data_alloc_map (IOT_DATA_STRING);
    iot_data_string_map_add (map, CLIENT_KEY, iot_data_alloc_string (CLIENT_ID, IOT_DATA_REF));
    iot_data_string_map_add (map, REQUEST_ID_KEY, iot_data_alloc_uuid_string());
    iot_data_string_map_add (map, OP_KEY, iot_data_alloc_string (DEVICE_OP_LIST, IOT_DATA_REF));
    iot_data_string_map_add (map, TYPE_KEY, iot_data_alloc_string (XRT_REQUEST_10, IOT_DATA_REF));
    return map;
  }
  
  iot_data_t* createGetMessage (const iot_data_t* device)
  {
    iot_data_t* map = iot_data_alloc_map(IOT_DATA_STRING);
    iot_data_string_map_add (map, CLIENT_KEY, iot_data_alloc_string (CLIENT_ID, IOT_DATA_REF));
    iot_data_string_map_add (map, REQUEST_ID_KEY, iot_data_alloc_uuid_string());
    iot_data_string_map_add (map, OP_KEY, iot_data_alloc_string (DEVICE_OP_GET, IOT_DATA_REF));
    iot_data_string_map_add (map, TYPE_KEY, iot_data_alloc_string (XRT_REQUEST_10, IOT_DATA_REF));
    iot_data_string_map_add (map, DEVICE_KEY, iot_data_add_ref (device));
    iot_data_string_map_add (map, RESOURCE_KEY, iot_data_alloc_string (DEVICE_RESOURCE, IOT_DATA_REF));
    return map;
  }

  bool waitForReply (int timeout_ms)
  {
    int elapsed_time = 0;
    while (!returned && elapsed_time < timeout_ms)
    {
      std::this_thread::sleep_for (std::chrono::milliseconds (1));
      elapsed_time += 1;
    }
    return returned != NULL;
  }

  void publishMessage (iot_data_t* data)
  {
    xrt_bus_pub_push (pub, data, true);
  }

  iot_data_t* getReturned()
  {
    return returned;
  }

  void freeReturned()
  {
    iot_data_free (returned);
  }

  iot_logger_t* getLogger()
  {
    return logger;
  }
};

class ControlLoop {
private:
  XRT* xrt;
  BUS* bus;

public:
  ControlLoop (const std::string& config_uri, const std::string& request_topic, const std::string& reply_topic)
  {
    xrt = new XRT (config_uri);
    bus = new BUS (xrt->getContainer(), request_topic, reply_topic);
  }

  ~ControlLoop()
  {
    delete bus;
    delete xrt;
  }

  void run()
  {
    xrt->start();
    bus->start();
    while (!XRT::stopped)
    {
      iot_data_t* data = bus->createListMessage();
      iot_log_info (bus->getLogger(), "request sent: %s", iot_data_to_json (data));
      bus->publishMessage (data);
      if (bus->waitForReply (100))
      {
        iot_data_t* returned = bus->getReturned();
        iot_log_info (bus->getLogger(), "received reply: %s", iot_data_to_json(returned));
        const iot_data_t * result = iot_data_string_map_get (returned,"result");
        const iot_data_t * device_list = iot_data_add_ref(iot_data_string_map_get (result,"devices"));
        iot_data_vector_iter_t iter;
        iot_data_vector_iter (device_list, &iter);
        while (iot_data_vector_iter_next (&iter))
        {
	        const iot_data_t *ele_data = iot_data_vector_iter_value (&iter);
      	  const iot_data_t *device_get =  bus->createGetMessage (ele_data);
      	  iot_log_info (bus->getLogger(), "request sent: %s %d", iot_data_to_json (device_get), iot_data_type (device_get));
      	  bus->publishMessage (iot_data_add_ref (data)); // list message gets freed on publish
      	  if (bus->waitForReply(100))
    	    {	
            iot_log_info (bus->getLogger(), "received reply: %s", iot_data_to_json (bus->getReturned()));
      	  }
      	  else
	        {
	          iot_log_info (bus->getLogger(), "did not receive reply");
	        }
	        sleep(5);
        }
      }
      else
      {
        iot_log_trace (bus->getLogger(), "did not receive reply");
      }
      bus->freeReturned();
      std::this_thread::sleep_for (std::chrono::seconds(5));
    }
    bus->stop();
    xrt->stop();
  }
};

int main()
{
  ControlLoop control_loop (getenv("XRT_CONFIG_DIR"), PUB_TOPIC, SUB_TOPIC);
  control_loop.run();

  return 0;
}
