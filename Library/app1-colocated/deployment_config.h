/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * XRT component configuration for spg_demo, compiled into the binary rather
 * than loaded from a config directory (see config_loader in spg_demo.c).
 *
 * These strings mirror the "config/" output of deployment.pkl. The XRT Pkl
 * schema can't render C string constants yet, so for now they're kept in
 * step with deployment.pkl by hand.
 * TODO: generate this header from deployment.pkl.
 */

#ifndef _APP1_DEPLOYMENT_CONFIG_H_
#define _APP1_DEPLOYMENT_CONFIG_H_

/* Ids of the components spg_demo looks up in the container */
#define LOGGER_ID "00-logger"
#define SPGAPP_POOL_ID "06-spgapp_pool"
#define BUS_ID "08-bus"

static const char main_config[] =
  "{"
    "\"00-logger\":\"IOT::Logger\","
    "\"01-config\":\"XRT::Config\","
    "\"02-sparkplug\":\"XRT::Sparkplug\","
    "\"03-logger_debug\":\"IOT::Logger\","
    "\"04-pool\":\"IOT::ThreadPool\","
    "\"05-sched_pool\":\"IOT::ThreadPool\","
    "\"06-spgapp_pool\":\"IOT::ThreadPool\","
    "\"07-sched\":\"IOT::Scheduler\","
    "\"08-bus\":\"XRT::Bus\","
    "\"09-mqtt_bridge\":\"XRT::MQTTBridge\","
    "\"10-sparkplug_node\":\"XRT::SparkplugNode\","
    "\"11-bacnet_ip_dev1\":\"XRT::BACnetIPDeviceService\","
    "\"12-bacnet_mstp_dev2\":\"XRT::BACnetMSTPDeviceService\""
  "}";

static const char logger_config[] =
  "{"
    "\"Name\":\"logger\","
    "\"Level\":\"Info\","
    "\"Start\":true"
  "}";

static const char config_config[] =
  "{"
    "\"Name\":\"config\","
    "\"ServerId\":\"app1-colocated-server\","
    "\"NodeId\":\"${SPARKPLUG_NODE}\","
    "\"Timeout\":0"
  "}";

static const char sparkplug_config[] =
  "{"
    "\"Name\":\"sparkplug\","
    "\"Namespace\":\"spBv1.0\","
    "\"Group\":\"${SPARKPLUG_GROUP}\","
    "\"EnableMetricQuality\":true,"
    "\"EnableMetricDescription\":false,"
    "\"EnableMetricTiming\":false,"
    "\"EnableMicrosecondTimestamp\":false,"
    "\"EnableMetricAttributes\":true,"
    "\"EnableMetricAckGood\":false,"
    "\"EnableFixedAliases\":false,"
    "\"EnableMetricType\":false,"
    "\"EnableMetricName\":false,"
    "\"EnableAckMetricName\":false,"
    "\"EnableMetricDefaultTimestamp\":false,"
    "\"EnableBadCMDIgnore\":false,"
    "\"EnableBadDataNull\":false,"
    "\"EnableCmdNullRead\":true,"
    "\"MQTTAppId\":\"XRT::MQTTBridge\""
  "}";

static const char logger_debug_config[] =
  "{"
    "\"Name\":\"logger_debug\","
    "\"Level\":\"Debug\","
    "\"Start\":true"
  "}";

static const char pool_config[] =
  "{"
    "\"Name\":\"pool\","
    "\"Logger\":\"00-logger\","
    "\"Threads\":6,"
    "\"MaxJobs\":0,"
    "\"ShutdownDelay\":200"
  "}";

static const char sched_pool_config[] =
  "{"
    "\"Name\":\"sched_pool\","
    "\"Logger\":\"00-logger\","
    "\"Threads\":4,"
    "\"MaxJobs\":0,"
    "\"ShutdownDelay\":200"
  "}";

static const char spgapp_pool_config[] =
  "{"
    "\"Name\":\"spgapp_pool\","
    "\"Logger\":\"00-logger\","
    "\"Threads\":5,"
    "\"MaxJobs\":0,"
    "\"ShutdownDelay\":200"
  "}";

static const char sched_config[] =
  "{"
    "\"Name\":\"sched\","
    "\"Logger\":\"00-logger\","
    "\"ThreadPool\":\"04-pool\""
  "}";

static const char bus_config[] =
  "{"
    "\"Name\":\"bus\","
    "\"Logger\":\"00-logger\","
    "\"Scheduler\":\"07-sched\","
    "\"ThreadPool\":\"04-pool\","
    "\"Topics\":[],"
    "\"StatsPublishInterval\":0"
  "}";

static const char mqtt_bridge_config[] =
  "{"
    "\"Name\":\"mqtt_bridge\","
    "\"Logger\":\"00-logger\","
    "\"Library\":\"libxrt-mqtt-bridge.so\","
    "\"Factory\":\"xrt_mqtt_bridge_factory\","
    "\"Bus\":\"08-bus\","
    "\"AcksTimeout\":0,"
    "\"AppTopic\":\"spBv1.0/STATE/XRT::MQTTBridge\","
    "\"UseDispatchThread\":true,"
    "\"DispatchThreadQueueSizeMax\":0,"
    "\"Patterns\":["
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DBIRTH/${SPARKPLUG_NODE}/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NBIRTH/${SPARKPLUG_NODE}\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DDEATH/${SPARKPLUG_NODE}/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NDEATH/${SPARKPLUG_NODE}\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DDATA/${SPARKPLUG_NODE}/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NDATA/${SPARKPLUG_NODE}\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DACK/${SPARKPLUG_NODE}/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NACK/${SPARKPLUG_NODE}\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "}"
    "],"
    "\"MQTTPatterns\":["
      "{"
        "\"Pattern\":\"spBv1.0/STATE/+\","
        "\"QoS\":0"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NCMD/${SPARKPLUG_NODE}\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "}"
    "],"
    "\"MQTTDynamicPatterns\":["
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DCMD/${SPARKPLUG_NODE}/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "}"
    "],"
    "\"MQTTConfig\":{"
      "\"ServerURI\":\"${XRT_MQTT_BROKER}\","
      "\"ClientID\":\"${SPARKPLUG_NODE}\","
      "\"QoS\":0,"
      "\"ClientConfig\":{"
        "\"KeepAliveInterval\":60,"
        "\"Username\":\"${XRT_MQTT_USERNAME}\","
        "\"Password\":\"${XRT_MQTT_PASSWORD}\","
        "\"ConnectTimeout\":0,"
        "\"DisconnectTimeout\":0,"
        "\"MQTTVersion\":5,"
        "\"WillConfig\":{"
          "\"Topic\":\"spBv1.0/${SPARKPLUG_GROUP}/NDEATH/${SPARKPLUG_NODE}\","
          "\"QoS\":1,"
          "\"Retain\":false,"
          "\"Transforms\":["
            "\"${SPARKPLUG_PROTO}\""
          "]"
        "},"
        "\"CleanStart\":true,"
        "\"SessionExpiry\":0,"
        "\"RetryInterval\":0,"
        "\"MinRetryInterval\":1,"
        "\"MaxRetryInterval\":60,"
        "\"MaxBufferedMessages\":100"
      "},"
      "\"FT_Mode\":false"
    "}"
  "}";

static const char sparkplug_node_config[] =
  "{"
    "\"Name\":\"sparkplug_node\","
    "\"Logger\":\"00-logger\","
    "\"Library\":\"libxrt-sparkplug.so\","
    "\"Factory\":\"xrt_sparkplug_factory\","
    "\"Bus\":\"08-bus\","
    "\"Scheduler\":\"07-sched\","
    "\"ThreadPool\":\"04-pool\","
    "\"StateDir\":\"${XRT_STATE_DIR}/sparkplug\","
    "\"NodeId\":\"${SPARKPLUG_NODE}\","
    "\"WaitTimeout\":0,"
    "\"EnableMetricLog\":true,"
    "\"EnableExitCmd\":true,"
    "\"EnableDiscovery\":true,"
    "\"EnableGroupCmd\":true,"
    "\"EnableServices\":true,"
    "\"EnableFixedAliases\":false,"
    "\"HeartbeatInterval\":60,"
    "\"CommandQueueMax\":0,"
    "\"AppStateWait\":[]"
  "}";

static const char bacnet_ip_dev1_config[] =
  "{"
    "\"Name\":\"bacnet_ip_dev1\","
    "\"Logger\":\"00-logger\","
    "\"Library\":\"libxrt-bacnet-ip-device-service.so\","
    "\"Factory\":\"xrt_bacnet_ip_device_service_factory\","
    "\"ProfileDir\":\"${XRT_STATE_DIR}/bacnet_ip_dev1/profiles\","
    "\"StateDir\":\"${XRT_STATE_DIR}/bacnet_ip_dev1\","
    "\"Scheduler\":\"07-sched\","
    "\"ThreadPool\":\"04-pool\","
    "\"SchedulesThreadPool\":\"05-sched_pool\","
    "\"Bus\":\"08-bus\","
    "\"AllowedFails\":0,"
    "\"RequestQueueMax\":4,"
    "\"CommandQueueMax\":4,"
    "\"DiscoveryInterval\":0,"
    "\"ScheduleDeadBand\":0,"
    "\"DiscoverInitialValues\":false,"
    "\"AutoBatchSize\":0,"
    "\"AutoBatchTimeout\":250,"
    "\"Timestamp\":true,"
    "\"AutoRegister\":false,"
    "\"PublishRegisteredDevices\":false,"
    "\"PublishAttributes\":false,"
    "\"EdgeXCompat\":false,"
    "\"ZeroNullReadings\":false,"
    "\"EnableDiscovery\":true,"
    "\"PreloadCache\":false,"
    "\"LiveCheckInterval\":15000,"
    "\"LiveCheckIntervalDelay\":0,"
    "\"Driver\":{"
      "\"DeviceObject\":{"
        "\"InstanceID\":0,"
        "\"VendorID\":1313,"
        "\"Location\":\"UK\","
        "\"Description\":\"IOTech Edge Xrt BACnet Device Service\","
        "\"ModelName\":\"IOTech Edge Xrt BACnet\","
        "\"ApplicationSoftware\":\"1.2\""
      "},"
      "\"APDUTimeout\":3000,"
      "\"APDURetries\":3,"
      "\"MultiBatchSize\":20,"
      "\"MultiRead\":true,"
      "\"MultiWrite\":true,"
      "\"ReadPropMultiFailover\":true,"
      "\"CancelStaleCOV\":true,"
      "\"DiscoverMode\":\"All\","
      "\"DiscoveryRetries\":1,"
      "\"IAmBroadcastInterval\":30,"
      "\"DiscoveryDuration\":3000,"
      "\"NetworkInterface\":\"\","
      "\"Port\":47808,"
      "\"BBMDPort\":47808,"
      "\"BBMDTimeToLive\":60000,"
      "\"BBMDRetryInterval\":30,"
      "\"WaitForBBMDRegistration\":true"
    "}"
  "}";

static const char bacnet_mstp_dev2_config[] =
  "{"
    "\"Name\":\"bacnet_mstp_dev2\","
    "\"Logger\":\"03-logger_debug\","
    "\"Library\":\"libxrt-bacnet-mstp-device-service.so\","
    "\"Factory\":\"xrt_bacnet_mstp_device_service_factory\","
    "\"ProfileDir\":\"${XRT_STATE_DIR}/bacnet_mstp_dev2/profiles\","
    "\"StateDir\":\"${XRT_STATE_DIR}/bacnet_mstp_dev2\","
    "\"Scheduler\":\"07-sched\","
    "\"ThreadPool\":\"04-pool\","
    "\"SchedulesThreadPool\":\"05-sched_pool\","
    "\"Bus\":\"08-bus\","
    "\"AllowedFails\":0,"
    "\"RequestQueueMax\":4,"
    "\"CommandQueueMax\":4,"
    "\"DiscoveryInterval\":0,"
    "\"ScheduleDeadBand\":0,"
    "\"DiscoverInitialValues\":false,"
    "\"AutoBatchSize\":0,"
    "\"AutoBatchTimeout\":250,"
    "\"Timestamp\":true,"
    "\"AutoRegister\":false,"
    "\"PublishRegisteredDevices\":false,"
    "\"PublishAttributes\":false,"
    "\"EdgeXCompat\":false,"
    "\"ZeroNullReadings\":false,"
    "\"EnableDiscovery\":true,"
    "\"PreloadCache\":false,"
    "\"LiveCheckInterval\":15000,"
    "\"LiveCheckIntervalDelay\":0,"
    "\"Driver\":{"
      "\"DeviceObject\":{"
        "\"InstanceID\":0,"
        "\"VendorID\":1313,"
        "\"Location\":\"UK\","
        "\"Description\":\"IOTech Edge Xrt BACnet Device Service\","
        "\"ModelName\":\"IOTech Edge Xrt BACnet\","
        "\"ApplicationSoftware\":\"1.2\""
      "},"
      "\"APDUTimeout\":3000,"
      "\"APDURetries\":3,"
      "\"MultiBatchSize\":20,"
      "\"MultiRead\":true,"
      "\"MultiWrite\":true,"
      "\"ReadPropMultiFailover\":true,"
      "\"CancelStaleCOV\":true,"
      "\"DiscoverMode\":\"All\","
      "\"DiscoveryRetries\":1,"
      "\"IAmBroadcastInterval\":30,"
      "\"DiscoveryDuration\":10000,"
      "\"SerialInterface\":\"/tmp/dev2-mstp\""
    "}"
  "}";

static const struct
{
  const char *id;
  const char *config;
} app_configs[] =
{
  {"main", main_config},
  {"00-logger", logger_config},
  {"01-config", config_config},
  {"02-sparkplug", sparkplug_config},
  {"03-logger_debug", logger_debug_config},
  {"04-pool", pool_config},
  {"05-sched_pool", sched_pool_config},
  {"06-spgapp_pool", spgapp_pool_config},
  {"07-sched", sched_config},
  {"08-bus", bus_config},
  {"09-mqtt_bridge", mqtt_bridge_config},
  {"10-sparkplug_node", sparkplug_node_config},
  {"11-bacnet_ip_dev1", bacnet_ip_dev1_config},
  {"12-bacnet_mstp_dev2", bacnet_mstp_dev2_config},
};

#endif
