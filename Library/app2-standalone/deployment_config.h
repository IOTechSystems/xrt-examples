/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * XRT component configuration for spg_standalone, compiled into the binary rather
 * than loaded from a config directory.
 *
 * TODO: generate this header from deployment.pkl.
 */

#ifndef _APP2_DEPLOYMENT_CONFIG_H_
#define _APP2_DEPLOYMENT_CONFIG_H_

static const char main_config[] =
  "{"
    "\"00-logger\":\"IOT::Logger\","
    "\"01-config\":\"XRT::Config\","
    "\"02-sparkplug\":\"XRT::Sparkplug\","
    "\"03-pool\":\"IOT::ThreadPool\","
    "\"04-sched_pool\":\"IOT::ThreadPool\","
    "\"05-spgapp_pool\":\"IOT::ThreadPool\","
    "\"06-sched\":\"IOT::Scheduler\","
    "\"07-bus\":\"XRT::Bus\","
    "\"08-mqtt_bridge\":\"XRT::MQTTBridge\","
    "\"09-spg_demo_app\":\"App::SparkplugDemo\""
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
    "\"ServerId\":\"app2-standalone-server\","
    "\"NodeId\":\"XRTLibSparkplugDemo2\","
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

static const char pool_config[] =
  "{"
    "\"Name\":\"pool\","
    "\"Logger\":\"00-logger\","
    "\"Threads\":4,"
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
    "\"ThreadPool\":\"03-pool\""
  "}";

static const char bus_config[] =
  "{"
    "\"Name\":\"bus\","
    "\"Logger\":\"00-logger\","
    "\"Scheduler\":\"06-sched\","
    "\"ThreadPool\":\"03-pool\","
    "\"Topics\":[],"
    "\"StatsPublishInterval\":0"
  "}";

static const char mqtt_bridge_config[] =
  "{"
    "\"Name\":\"mqtt_bridge\","
    "\"Logger\":\"00-logger\","
    "\"Library\":\"libxrt-mqtt-bridge.so\","
    "\"Factory\":\"xrt_mqtt_bridge_factory\","
    "\"Bus\":\"07-bus\","
    "\"AcksTimeout\":0,"
    "\"AppTopic\":\"spBv1.0/STATE/XRT::MQTTBridge\","
    "\"UseDispatchThread\":true,"
    "\"DispatchThreadQueueSizeMax\":0,"
    "\"Patterns\":["
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NCMD/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DCMD/+/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/STATE/XRTLibSparkplugDemo2\","
        "\"QoS\":1,"
        "\"Retain\":true"
      "}"
    "],"
    "\"MQTTPatterns\":["
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NBIRTH/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NDEATH/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NDATA/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/NACK/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DBIRTH/+/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DDEATH/+/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DDATA/+/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/${SPARKPLUG_GROUP}/DACK/+/+\","
        "\"QoS\":0,"
        "\"Transforms\":["
          "\"${SPARKPLUG_PROTO}\""
        "]"
      "},"
      "{"
        "\"Pattern\":\"spBv1.0/STATE/+\","
        "\"QoS\":1"
      "}"
    "],"
    "\"MQTTDynamicPatterns\":[],"
    "\"MQTTConfig\":{"
      "\"ServerURI\":\"${XRT_MQTT_BROKER}\","
      "\"ClientID\":\"XRTLibSparkplugDemo2\","
      "\"QoS\":0,"
      "\"ClientConfig\":{"
        "\"KeepAliveInterval\":10,"
        "\"Username\":\"${XRT_MQTT_USERNAME}\","
        "\"Password\":\"${XRT_MQTT_PASSWORD}\","
        "\"ConnectTimeout\":0,"
        "\"DisconnectTimeout\":0,"
        "\"MQTTVersion\":5,"
        "\"WillConfig\":{"
          "\"Topic\":\"spBv1.0/STATE/XRTLibSparkplugDemo2\","
          "\"QoS\":1,"
          "\"Retain\":true"
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

static const char spg_demo_app_config[] =
  "{"
    "\"Name\":\"spg_demo_app\","
    "\"Logger\":\"00-logger\","
    "\"Bus\":\"07-bus\","
    "\"ThreadPool\":\"05-spgapp_pool\","
    "\"AppId\":\"XRTLibSparkplugDemo2\","
    "\"WriteDevice\":\"Dev3\","
    "\"WriteMetric\":\"analog_output_0:present-value\","
    "\"WriteValue\":789.0"
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
  {"03-pool", pool_config},
  {"04-sched_pool", sched_pool_config},
  {"05-spgapp_pool", spgapp_pool_config},
  {"06-sched", sched_config},
  {"07-bus", bus_config},
  {"08-mqtt_bridge", mqtt_bridge_config},
  {"09-spg_demo_app", spg_demo_app_config},
};

#endif
