/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Standalone Sparkplug client for XRT 3.4.
 *
 * Unlike sparkplug-colocated/, this process has no xrt_bus_t and no
 * iot_container_t at all - it is not "XRT embedded in a program", it is a
 * plain MQTT client. It talks to whatever XRT deployment is already
 * publishing Sparkplug B on the broker (e.g. ../sparkplug-colocated, or any
 * other XRT Sparkplug node) purely over MQTT:
 *
 *   - Connects to the broker directly via Paho MQTT C (MQTTAsync).
 *   - Subscribes to "spBv1.0/<group>/#" and decodes each message's raw
 *     protobuf payload with xrt_xform_spb_decode() - the same codec XRT's
 *     own Sparkplug node/application uses internally, exposed as a
 *     bus-free, container-free function pair (xrt_xform_spb_decode/encode)
 *     operating purely on iot_data_t.
 *   - When it sees the demo device birth, it builds a DCMD with
 *     xrt_spg_metric_add()/xrt_xform_spb_encode() and publishes it back to
 *     the broker.
 *
 * What's deliberately NOT done here (kept simple for the example):
 *   - No alias table. Sparkplug allows DATA messages to reference a metric
 *     by numeric alias only (set in the preceding BIRTH) to save bytes; a
 *     production consumer must record name<->alias per node/device from
 *     BIRTH and resolve later DATA messages against it, exactly as
 *     xrt_spg_app_t does internally. This example only reads whatever
 *     name/value/alias fields are present on each message and logs them.
 *   - No sequence-number/rebirth handling, no NDEATH/DDEATH bookkeeping, no
 *     STATE topic handling (STATE lives under "spBv1.0/STATE/<host>", a
 *     different topic shape, and carries a plain "ONLINE"/"OFFLINE" string
 *     rather than Sparkplug protobuf, so it never matches the "#" wildcard
 *     subscription below).
 *
 * This is the "own no XRT/iot dependency at all" end of the spectrum was
 * ruled out for now: this example still uses IOT's iot_data_t and XRT's own
 * Sparkplug B codec (xrt_xform_spb_*) and metric builder (xrt_spg_metric_*)
 * rather than hand-rolling protobuf, per the brief to use "the iot library
 * functions for sparkplug decoding etc for now". Swapping those for a fully
 * independent protobuf implementation would only change encode/decode; the
 * MQTT transport and process structure here would stay the same.
 */

#include <inttypes.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <MQTTAsync.h>

#include "iot/data.h"
#include "iot/logger.h"
#include "iot/time.h"
#include "xrt/ops.h"
#include "xrt/xform_spb.h"
#include "devsdk/devsdk.h"
#include "devsdk/spg.h"

#define WRITE_DEVICE "Virtual-Device"
#define WRITE_METRIC "StoreInt32Value"
#define WRITE_VALUE 456
#define CLIENT_ID "XRTStandaloneSparkplugClient"
#define TOPIC_MAX 256

static atomic_bool stopped = ATOMIC_VAR_INIT (false);

typedef struct
{
  MQTTAsync client;
  iot_logger_t *logger;
  char group[64];
  atomic_bool device_written;
} app_ctx_t;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
}

/* Publishes a DCMD writing WRITE_METRIC on WRITE_DEVICE, built directly as
 * an iot_data_t Sparkplug payload map (no bus, no device profile) and
 * encoded to protobuf with the same xform used by XRT's own MQTT bridge. */
static void publish_write_cmd (app_ctx_t *ctx, const char *node, const char *device)
{
  iot_data_t *metrics = NULL;
  iot_data_t *payload = xrt_spg_msg (&metrics, NULL);

  xrt_spg_metric_opts_t opts = {0};
  opts.add_type = true;
  opts.no_alias = true; /* alias unknown here - this example does not track the BIRTH alias table, see file header */

  iot_data_t *name = iot_data_alloc_string (WRITE_METRIC, IOT_DATA_REF);
  xrt_spg_metric_add (metrics, name, iot_data_alloc_i32 (WRITE_VALUE), XRT_SPG_TYPE_INT32, &opts);
  iot_data_free (name);

  iot_data_t *binary = xrt_xform_spb_encode (payload, ctx->logger);
  if (binary == NULL)
  {
    iot_log_error (ctx->logger, "failed to encode DCMD payload");
    return;
  }

  char topic[TOPIC_MAX];
  snprintf (topic, sizeof (topic), "spBv1.0/%s/DCMD/%s/%s", ctx->group, node, device);

  MQTTAsync_responseOptions ropts = MQTTAsync_responseOptions_initializer;
  MQTTAsync_message msg = MQTTAsync_message_initializer;
  msg.payload = (void *) iot_data_address (binary);
  msg.payloadlen = (int) iot_data_array_length (binary);
  msg.qos = 1;
  msg.retained = 0;

  iot_log_info (ctx->logger, "issuing DCMD on '%s': '%s' = %d", topic, WRITE_METRIC, WRITE_VALUE);
  int rc = MQTTAsync_sendMessage (ctx->client, topic, &msg, &ropts);
  if (rc != MQTTASYNC_SUCCESS)
  {
    iot_log_error (ctx->logger, "failed to send DCMD, rc=%d", rc);
  }
  iot_data_free (binary);
}

/* Logs every metric in a decoded Sparkplug payload map, and triggers the
 * one-shot DCMD demo write on the target device's birth. */
static void process_sparkplug_payload (app_ctx_t *ctx, const char *msgtype, const char *node, const char *device, iot_data_t *payload)
{
  const iot_data_t *metrics = iot_data_map_get (payload, IOT_DATA_STATIC (xrt_spg_consts.metrics));
  if (metrics == NULL)
  {
    iot_data_free (payload);
    return;
  }

  iot_data_vector_iter_t iter;
  iot_data_vector_iter (metrics, &iter);
  while (iot_data_vector_iter_next (&iter))
  {
    const iot_data_t *metric = iot_data_vector_iter_value (&iter);
    const char *name = iot_data_map_get_string (metric, IOT_DATA_STATIC (iot_data_consts.name));
    const iot_data_t *alias = iot_data_map_get (metric, IOT_DATA_STATIC (xrt_spg_consts.alias));
    const iot_data_t *value = iot_data_map_get (metric, IOT_DATA_STATIC (devsdk_consts.value_key));

    char *json = value ? iot_data_to_json (value) : NULL;
    iot_log_info
    (
      ctx->logger,
      "%s %s/%s metric name='%s' alias=%" PRIu64 " value=%s",
      msgtype, node, device ? device : "-",
      name ? name : "(alias only)",
      alias ? iot_data_ui64 (alias) : 0,
      json ? json : "(none)"
    );
    free (json);
  }

  if (device != NULL && strcmp (device, WRITE_DEVICE) == 0 && strcmp (msgtype, "DBIRTH") == 0 && !atomic_exchange (&ctx->device_written, true))
  {
    publish_write_cmd (ctx, node, device);
  }

  iot_data_free (payload);
}

/* Splits "spBv1.0/<group>/<TYPE>/<node>[/<device>]" into its components.
 * Returns false for anything that doesn't match that shape (e.g. STATE
 * topics, which this client never subscribes to anyway). */
static bool parse_topic (char *topic, char **msgtype, char **node, char **device)
{
  char *save = NULL;
  char *namespace_seg = strtok_r (topic, "/", &save);
  char *group_seg = strtok_r (NULL, "/", &save);
  *msgtype = strtok_r (NULL, "/", &save);
  *node = strtok_r (NULL, "/", &save);
  *device = strtok_r (NULL, "/", &save);
  return namespace_seg && group_seg && *msgtype && *node;
}

static int msgarrvd (void *context, char *topicName, int topicLen, MQTTAsync_message *message)
{
  (void) topicLen;
  app_ctx_t *ctx = context;

  char topic_copy[TOPIC_MAX];
  snprintf (topic_copy, sizeof (topic_copy), "%s", topicName);

  char *msgtype = NULL, *node = NULL, *device = NULL;
  if (parse_topic (topic_copy, &msgtype, &node, &device))
  {
    iot_data_t *binary = iot_data_alloc_binary (message->payload, (uint32_t) message->payloadlen, IOT_DATA_REF);
    iot_data_t *decoded = xrt_xform_spb_decode (binary, ctx->logger);
    iot_data_free (binary);
    if (decoded)
    {
      process_sparkplug_payload (ctx, msgtype, node, device, decoded);
    }
  }

  MQTTAsync_freeMessage (&message);
  MQTTAsync_free (topicName);
  return 1;
}

static void connlost (void *context, char *cause)
{
  app_ctx_t *ctx = context;
  iot_log_error (ctx->logger, "connection lost: %s", cause ? cause : "(unknown)");
}

static void onSubscribeFailure (void *context, MQTTAsync_failureData *response)
{
  app_ctx_t *ctx = context;
  iot_log_error (ctx->logger, "subscribe failed, code=%d", response ? response->code : 0);
}

static void onConnectFailure (void *context, MQTTAsync_failureData *response)
{
  app_ctx_t *ctx = context;
  iot_log_error (ctx->logger, "connect failed, code=%d", response ? response->code : 0);
  atomic_store (&stopped, true);
}

static void onConnect (void *context, MQTTAsync_successData *response)
{
  (void) response;
  app_ctx_t *ctx = context;
  char topic[TOPIC_MAX];
  snprintf (topic, sizeof (topic), "spBv1.0/%s/#", ctx->group);

  MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
  opts.context = ctx;
  opts.onFailure = onSubscribeFailure;

  iot_log_info (ctx->logger, "connected, subscribing to '%s'", topic);
  MQTTAsync_subscribe (ctx->client, topic, 1, &opts);
}

int main (void)
{
  struct sigaction signal_action = {0};
  signal_action.sa_handler = signal_handler;
  signal_action.sa_flags = SA_RESETHAND;
  sigaction (SIGINT, &signal_action, NULL);
  sigaction (SIGTERM, &signal_action, NULL);
  sigaction (SIGHUP, &signal_action, NULL);

  const char *broker = getenv ("XRT_MQTT_BROKER");
  const char *group = getenv ("SPARKPLUG_GROUP");
  const char *username = getenv ("XRT_MQTT_USERNAME");
  const char *password = getenv ("XRT_MQTT_PASSWORD");

  app_ctx_t ctx = {0};
  ctx.logger = iot_logger_alloc ("standalone", IOT_LOG_INFO, true);
  snprintf (ctx.group, sizeof (ctx.group), "%s", group ? group : "iotech");

  MQTTAsync_create (&ctx.client, broker ? broker : "tcp://localhost:1883", CLIENT_ID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
  MQTTAsync_setCallbacks (ctx.client, &ctx, connlost, msgarrvd, NULL);

  MQTTAsync_connectOptions conn_opts = MQTTAsync_connectOptions_initializer;
  conn_opts.cleansession = 1;
  conn_opts.context = &ctx;
  conn_opts.onSuccess = onConnect;
  conn_opts.onFailure = onConnectFailure;
  if (username && username[0]) conn_opts.username = username;
  if (password && password[0]) conn_opts.password = password;

  iot_log_info (ctx.logger, "connecting to '%s' as '%s', group '%s'", broker ? broker : "tcp://localhost:1883", CLIENT_ID, ctx.group);
  int rc = MQTTAsync_connect (ctx.client, &conn_opts);
  if (rc != MQTTASYNC_SUCCESS)
  {
    iot_log_error (ctx.logger, "failed to start connect, rc=%d", rc);
    return 1;
  }

  while (!atomic_load (&stopped))
  {
    sleep (1);
  }

  MQTTAsync_disconnectOptions disc_opts = MQTTAsync_disconnectOptions_initializer;
  MQTTAsync_disconnect (ctx.client, &disc_opts);
  MQTTAsync_destroy (&ctx.client);
  iot_logger_free (ctx.logger);
  return 0;
}
