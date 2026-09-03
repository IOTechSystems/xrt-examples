/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Minimal Sparkplug B publisher, standing in for ../sparkplug-colocated/
 * when all you need is *something* on the broker for spg_standalone.c to
 * talk to.
 *
 * ../sparkplug-colocated/ is a full XRT deployment (two device services, a
 * Sparkplug node, an MQTT bridge, a Docker BACnet/IP simulator, a container
 * config tree) - a lot to stand up just to give spg_standalone.c a NBIRTH/
 * DBIRTH to subscribe to. This program produces the same shape of Sparkplug
 * B traffic with none of that: like spg_standalone.c itself, it is a plain
 * Paho MQTT client with no xrt_bus_t and no iot_container_t, using only
 * IOT's iot_data_t and XRT's Sparkplug B codec/metric-builder functions
 * (xrt_xform_spb_encode, xrt_spg_msg/xrt_spg_cert_base/xrt_spg_metric_add)
 * directly - the same low-level pieces spg_standalone.c uses to decode and
 * to build its DCMD, just used here to encode NBIRTH/DBIRTH/DDATA instead.
 *
 * What it does:
 *   - Publishes one NBIRTH for this node (with a "bdSeq" metric, as the
 *     Sparkplug B spec requires) and one DBIRTH for a single fake device,
 *     "Virtual-Device", with one metric: "StoreInt32Value" - the same
 *     device/metric names spg_standalone.c already knows to watch for and
 *     write to.
 *   - Re-publishes a DDATA for that device every few seconds.
 *   - Subscribes to its own device's DCMD topic; any write it receives
 *     there (e.g. spg_standalone.c's demo write) updates the stored value
 *     and is immediately reflected back out in a DDATA - the same
 *     round-trip ../sparkplug-colocated/'s README describes, minus
 *     everything colocated needs to produce it.
 *
 * What's deliberately NOT done here (kept simple for the example, same
 * spirit as spg_standalone.c):
 *   - No alias table, no rebirth/NDEATH handling, no persisted bdSeq across
 *     restarts (it is always 0 - fine for a throwaway demo publisher, not
 *     spec-compliant for a real Edge Node).
 *   - Only one device, one metric. Real device services/nodes would
 *     aggregate many.
 */

#include <inttypes.h>
#include <signal.h>
#include <stdatomic.h>
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

#define DEVICE_NAME "Virtual-Device"
#define METRIC_NAME "StoreInt32Value"
#define INITIAL_VALUE 123
#define CLIENT_ID "XRTMinimalSparkplugPublisher"
#define TOPIC_MAX 256
#define PUBLISH_INTERVAL_SECS 3

static atomic_bool stopped = ATOMIC_VAR_INIT (false);

typedef struct
{
  MQTTAsync client;
  iot_logger_t *logger;
  char group[64];
  char node[64];
  atomic_int value;
  atomic_uint seq;
} app_ctx_t;

static void signal_handler (int sig)
{
  (void) sig;
  atomic_store (&stopped, true);
}

/* Sparkplug B requires a strictly increasing 0-255 sequence number on every
 * message after NBIRTH; xrt_spg_seq_publish() does this for you when
 * publishing via an xrt_bus_t, but there is no bus here, so it's done by
 * hand. */
static uint64_t next_seq (app_ctx_t *ctx)
{
  return atomic_fetch_add (&ctx->seq, 1u) % 256u;
}

static bool encode_and_send (app_ctx_t *ctx, iot_data_t *payload, const char *topic)
{
  iot_data_t *binary = xrt_xform_spb_encode (payload, ctx->logger);
  if (binary == NULL)
  {
    iot_log_error (ctx->logger, "failed to encode payload for '%s'", topic);
    return false;
  }

  MQTTAsync_responseOptions ropts = MQTTAsync_responseOptions_initializer;
  MQTTAsync_message msg = MQTTAsync_message_initializer;
  msg.payload = (void *) iot_data_address (binary);
  msg.payloadlen = (int) iot_data_array_length (binary);
  msg.qos = 1;
  msg.retained = 0;

  int rc = MQTTAsync_sendMessage (ctx->client, topic, &msg, &ropts);
  if (rc != MQTTASYNC_SUCCESS)
  {
    iot_log_error (ctx->logger, "failed to publish '%s', rc=%d", topic, rc);
  }
  iot_data_free (binary);
  return rc == MQTTASYNC_SUCCESS;
}

/* One-off NBIRTH: just the mandatory "bdSeq" metric, no device data. */
static void publish_nbirth (app_ctx_t *ctx)
{
  uint8_t bd_seq = 0;
  iot_data_t *metrics = NULL;
  iot_data_t *payload = xrt_spg_cert_base (&metrics, &bd_seq, iot_time_nsecs ());
  iot_data_map_add (payload, IOT_DATA_STATIC (xrt_spg_consts.seq), iot_data_alloc_ui64 (next_seq (ctx)));

  char topic[TOPIC_MAX];
  snprintf (topic, sizeof (topic), "spBv1.0/%s/NBIRTH/%s", ctx->group, ctx->node);
  iot_log_info (ctx->logger, "publishing NBIRTH on '%s'", topic);
  encode_and_send (ctx, payload, topic);
}

/* Publishes DBIRTH (first_birth=true) or DDATA (first_birth=false) for
 * DEVICE_NAME, carrying the current value of METRIC_NAME. */
static void publish_device_metric (app_ctx_t *ctx, bool first_birth)
{
  iot_data_t *metrics = NULL;
  iot_data_t *payload = xrt_spg_msg (&metrics, NULL);
  iot_data_map_add (payload, IOT_DATA_STATIC (xrt_spg_consts.seq), iot_data_alloc_ui64 (next_seq (ctx)));

  xrt_spg_metric_opts_t opts = {0};
  opts.add_type = true;
  opts.no_alias = true; /* no alias table tracked here, same as spg_standalone.c's DCMD write */

  iot_data_t *name = iot_data_alloc_string (METRIC_NAME, IOT_DATA_REF);
  xrt_spg_metric_add (metrics, name, iot_data_alloc_i32 (atomic_load (&ctx->value)), XRT_SPG_TYPE_INT32, &opts);
  iot_data_free (name);

  char topic[TOPIC_MAX];
  snprintf (topic, sizeof (topic), "spBv1.0/%s/%s/%s/%s", ctx->group, first_birth ? "DBIRTH" : "DDATA", ctx->node, DEVICE_NAME);
  iot_log_info (ctx->logger, "publishing %s on '%s': '%s' = %d", first_birth ? "DBIRTH" : "DDATA", topic, METRIC_NAME, atomic_load (&ctx->value));
  encode_and_send (ctx, payload, topic);
}

/* Applies an incoming DCMD write to the stored value, then immediately
 * republishes DDATA - the round-trip a real Sparkplug node performs after
 * a write lands. */
static void handle_dcmd (app_ctx_t *ctx, MQTTAsync_message *message)
{
  iot_data_t *binary = iot_data_alloc_binary (message->payload, (uint32_t) message->payloadlen, IOT_DATA_REF);
  iot_data_t *decoded = xrt_xform_spb_decode (binary, ctx->logger);
  iot_data_free (binary);
  if (decoded == NULL) return;

  const iot_data_t *metrics = iot_data_map_get (decoded, IOT_DATA_STATIC (xrt_spg_consts.metrics));
  if (metrics != NULL)
  {
    iot_data_vector_iter_t iter;
    iot_data_vector_iter (metrics, &iter);
    while (iot_data_vector_iter_next (&iter))
    {
      const iot_data_t *metric = iot_data_vector_iter_value (&iter);
      const char *name = iot_data_map_get_string (metric, IOT_DATA_STATIC (iot_data_consts.name));
      const iot_data_t *value = iot_data_map_get (metric, IOT_DATA_STATIC (devsdk_consts.value_key));
      if (name != NULL && strcmp (name, METRIC_NAME) == 0 && value != NULL)
      {
        int32_t new_value = iot_data_i32 (value);
        iot_log_info (ctx->logger, "DCMD write: '%s' = %d", METRIC_NAME, new_value);
        atomic_store (&ctx->value, new_value);
        publish_device_metric (ctx, false);
      }
    }
  }
  iot_data_free (decoded);
}

static int msgarrvd (void *context, char *topicName, int topicLen, MQTTAsync_message *message)
{
  (void) topicLen;
  app_ctx_t *ctx = context;
  iot_log_info (ctx->logger, "received message on '%s'", topicName);
  handle_dcmd (ctx, message);
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
  snprintf (topic, sizeof (topic), "spBv1.0/%s/DCMD/%s/%s", ctx->group, ctx->node, DEVICE_NAME);

  MQTTAsync_responseOptions opts = MQTTAsync_responseOptions_initializer;
  opts.context = ctx;
  opts.onFailure = onSubscribeFailure;

  iot_log_info (ctx->logger, "connected, subscribing to '%s'", topic);
  MQTTAsync_subscribe (ctx->client, topic, 1, &opts);

  publish_nbirth (ctx);
  publish_device_metric (ctx, true);
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
  const char *node = getenv ("SPARKPLUG_NODE");
  const char *username = getenv ("XRT_MQTT_USERNAME");
  const char *password = getenv ("XRT_MQTT_PASSWORD");

  app_ctx_t ctx = {0};
  ctx.logger = iot_logger_alloc ("publisher", IOT_LOG_INFO, true);
  atomic_init (&ctx.value, INITIAL_VALUE);
  atomic_init (&ctx.seq, 0u);
  snprintf (ctx.group, sizeof (ctx.group), "%s", group ? group : "iotech");
  snprintf (ctx.node, sizeof (ctx.node), "%s", node ? node : "publisher-node");

  MQTTAsync_create (&ctx.client, broker ? broker : "tcp://localhost:1883", CLIENT_ID, MQTTCLIENT_PERSISTENCE_NONE, NULL);
  MQTTAsync_setCallbacks (ctx.client, &ctx, connlost, msgarrvd, NULL);

  MQTTAsync_connectOptions conn_opts = MQTTAsync_connectOptions_initializer;
  conn_opts.cleansession = 1;
  conn_opts.context = &ctx;
  conn_opts.onSuccess = onConnect;
  conn_opts.onFailure = onConnectFailure;
  if (username && username[0]) conn_opts.username = username;
  if (password && password[0]) conn_opts.password = password;

  iot_log_info (ctx.logger, "connecting to '%s' as '%s', node '%s', group '%s'", broker ? broker : "tcp://localhost:1883", CLIENT_ID, ctx.node, ctx.group);
  int rc = MQTTAsync_connect (ctx.client, &conn_opts);
  if (rc != MQTTASYNC_SUCCESS)
  {
    iot_log_error (ctx.logger, "failed to start connect, rc=%d", rc);
    return 1;
  }

  while (!atomic_load (&stopped))
  {
    sleep (PUBLISH_INTERVAL_SECS);
    if (!atomic_load (&stopped))
    {
      publish_device_metric (&ctx, false);
    }
  }

  MQTTAsync_disconnectOptions disc_opts = MQTTAsync_disconnectOptions_initializer;
  MQTTAsync_disconnect (ctx.client, &disc_opts);
  MQTTAsync_destroy (&ctx.client);
  iot_logger_free (ctx.logger);
  return 0;
}
