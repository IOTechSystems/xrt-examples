/*
 * Copyright (c) 2018-2021
 * IoTech Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 */

#include <devsdk/devsdk.h>
#include <devsdk/devsdk-component.h>
#include "example-device.h"

typedef struct example_driver
{
  iot_logger_t *lc;
  pthread_mutex_t mutex;
  unsigned rndseed;
  iot_data_t *sequencemap;
} example_driver;


/* --- Initialize ---- */
/* Initialize performs protocol-specific initialization for the device
 * service.
 */
static bool example_init (void *impl, struct iot_logger_t *lc, const iot_data_t *config)
{
  example_driver *driver = (example_driver *) impl;

  const iot_data_t *seedconf = iot_data_string_map_get (config, "Seed");
  if (seedconf)
  {
    driver->rndseed = iot_data_i64 (seedconf);
  }
  else
  {
    time_t t;
    driver->rndseed = time(&t);
  }
  iot_log_info (lc, "Seeding RNG with %u", driver->rndseed);

  driver->lc = lc;
  driver->sequencemap = iot_data_alloc_map (IOT_DATA_STRING);
  pthread_mutex_init(&driver->mutex, NULL);
  iot_log_debug (driver->lc, "Init Virtual Device Service");

  return true;
}

static iot_data_t *getDeviceMap (iot_data_t *seqmap, const char *devname)
{
  iot_data_t *result = (iot_data_t *)iot_data_string_map_get (seqmap, devname);
  if (result == NULL)
  {
    result = iot_data_alloc_map (IOT_DATA_STRING);
    iot_data_string_map_add (seqmap, devname, result);
  }
  return result;
}

static iot_data_t *addData (iot_data_type_t type, const iot_data_t *x, const iot_data_t *y)
{
  switch (type)
  {
    case IOT_DATA_INT8: return iot_data_alloc_i8 (iot_data_i8 (x) + iot_data_i8 (y));
    case IOT_DATA_UINT8: return iot_data_alloc_ui8 (iot_data_ui8 (x) + iot_data_ui8 (y));
    case IOT_DATA_INT16: return iot_data_alloc_i16 (iot_data_i16 (x) + iot_data_i16 (y));
    case IOT_DATA_UINT16: return iot_data_alloc_ui16 (iot_data_ui16 (x) + iot_data_ui16 (y));
    case IOT_DATA_INT32: return iot_data_alloc_i32 (iot_data_i32 (x) + iot_data_i32 (y));
    case IOT_DATA_UINT32: return iot_data_alloc_ui32 (iot_data_ui32 (x) + iot_data_ui32 (y));
    case IOT_DATA_INT64: return iot_data_alloc_i64 (iot_data_i64 (x) + iot_data_i64 (y));
    case IOT_DATA_UINT64: return iot_data_alloc_ui64 (iot_data_ui64 (x) + iot_data_ui64 (y));
    case IOT_DATA_FLOAT32: return iot_data_alloc_f32 (iot_data_f32 (x) + iot_data_f32 (y));
    case IOT_DATA_FLOAT64: return iot_data_alloc_f64 (iot_data_f64 (x) + iot_data_f64 (y));
    default: break;
  }
  return NULL;
}

/* rand() does not return a full 32-bit range so we compose from 16 bits */

static uint32_t random32 (unsigned *seedp)
{
  uint32_t result = rand_r (seedp) % 65536;
  result <<= 16;
  result += rand_r (seedp) % 65536;
  return result;
}

static uint64_t random64 (unsigned *seedp)
{
  uint64_t result = random32 (seedp);
  result <<= 32;
  result += random32 (seedp);
  return result;
}

static uint32_t randomU32 (unsigned *seedp, uint32_t min, uint32_t max)
{
  uint32_t divisor = max - min;
  divisor++;
  return min + (divisor ? (random32 (seedp) % divisor) : random32 (seedp));
}

static int32_t randomI32 (unsigned *seedp, int32_t min, int32_t max)
{
  uint32_t divisor = max - min;
  divisor++;
  return min + (divisor ? (random32 (seedp) % divisor) : random32 (seedp));
}

static uint64_t randomU64 (unsigned *seedp, uint64_t min, uint64_t max)
{
  uint64_t divisor = max - min;
  divisor++;
  return min + (divisor ? (random64 (seedp) % divisor) : random64 (seedp));
}

static int64_t randomI64 (unsigned *seedp, int64_t min, int64_t max)
{
  uint64_t divisor = max - min;
  divisor++;
  return min + (divisor ? (random64 (seedp) % divisor) : random64 (seedp));
}

static double randomF64 (unsigned *seedp, double min, double max)
{
  double rnd = (double) rand_r (seedp) / (double) RAND_MAX;
  return 4.0 * ((min / 4.0) + (rnd * ((max / 4.0) - (min / 4.0))));
}

static iot_data_t *generateRandom (unsigned *seedp, iot_data_type_t type, const iot_data_t *min, const iot_data_t *max)
{
  switch (type)
  {
    case IOT_DATA_INT8: return iot_data_alloc_i8 (iot_data_i8 (min) + (rand_r (seedp) % (iot_data_i8 (max) - iot_data_i8 (min) + 1)));
    case IOT_DATA_UINT8: return iot_data_alloc_ui8 (iot_data_ui8 (min) + (rand_r (seedp) % (iot_data_ui8 (max) - iot_data_ui8 (min) + 1)));
    case IOT_DATA_INT16: return iot_data_alloc_i16 (iot_data_i16 (min) + (rand_r (seedp) % (iot_data_i16 (max) - iot_data_i16 (min) + 1)));
    case IOT_DATA_UINT16: return iot_data_alloc_ui16 (iot_data_ui16 (min) + (rand_r (seedp) % (iot_data_ui16 (max) - iot_data_ui16 (min) + 1)));
    case IOT_DATA_INT32: return iot_data_alloc_i32 (randomI32 (seedp, iot_data_i32 (min), iot_data_i32 (max)));
    case IOT_DATA_UINT32: return iot_data_alloc_ui32 (randomU32 (seedp, iot_data_ui32 (min), iot_data_ui32 (max)));
    case IOT_DATA_INT64: return iot_data_alloc_i64 (randomI64 (seedp, iot_data_i64 (min), iot_data_i64 (max)));
    case IOT_DATA_UINT64: return iot_data_alloc_ui64 (randomU64 (seedp, iot_data_ui64 (min), iot_data_ui64 (max)));
    case IOT_DATA_FLOAT32: return iot_data_alloc_f32 (iot_data_f32 (min) + ((double)rand_r (seedp) / RAND_MAX) * ((double)iot_data_f32 (max) - iot_data_f32 (min)));
    case IOT_DATA_FLOAT64: return iot_data_alloc_f64 (randomF64 (seedp, iot_data_f64 (min), iot_data_f64 (max)));
    default: break;
  }
  return NULL;
}

/* ---- Get ---- */
/* Get triggers an asynchronous protocol specific GET operation.
 * The device to query is specified by the protocols. nreadings is
 * the number of values being requested and defines the size of the requests
 * and readings arrays. For each value, the commandrequest holds information
 * as to what is being requested. The implementation of this method should
 * query the device accordingly and write the resulting value into the
 * commandresult.
 *
 * Note - In a commandrequest, the DeviceResource represents a deviceResource
 * which is defined in the device profile.
*/
static bool example_get_handler
(
  void *impl,
  const char *devname,
  const devsdk_protocols *protocols,
  uint32_t nreadings,
  const devsdk_commandrequest *requests,
  devsdk_commandresult *readings,
  const devsdk_nvpairs *qparms,
  iot_data_t **exception
)
{
  example_driver *driver = (example_driver *) impl;

  /* Access the location of the device to be accessed and log it */
  iot_log_debug (driver->lc, "GET on device:");
  const devsdk_nvpairs *nvs = devsdk_protocols_properties (protocols, "Other");
  for (const devsdk_nvpairs *nv = nvs; nv; nv = nv->next)
  {
    iot_log_debug (driver->lc, "  %s = %s", nv->name, nv->value);
  }

  pthread_mutex_lock(&driver->mutex);
  iot_data_t *device = getDeviceMap (driver->sequencemap, devname);
  for (uint32_t i = 0; i < nreadings; i++)
  {
    const char *seqtype = devsdk_nvpairs_value (requests[i].attributes, "sequenceType");
    if (seqtype)
    {
      if (strcmp (seqtype, "arithmetic") == 0)
      {
        iot_data_t *newval;
        const iot_data_t *currval = iot_data_string_map_get (device, requests[i].resname);
        if (currval)
        {
          const char *diff = devsdk_nvpairs_value (requests[i].attributes, "difference");
          iot_data_t *ival = iot_data_alloc_from_string (iot_typecode_type (requests[i].type), diff ? diff : "1");
          newval = addData (iot_typecode_type (requests[i].type), currval, ival);
          iot_data_free (ival);
        }
        else
        {
          const char *initial = devsdk_nvpairs_value (requests[i].attributes, "firstValue");
          newval = iot_data_alloc_from_string (iot_typecode_type (requests[i].type), initial ? initial : "1");
        }
        readings[i].value = newval;
        iot_data_string_map_add (device, requests[i].resname, newval);
        iot_data_add_ref (newval);
      }
      else if (strcmp (seqtype, "random") == 0)
      {
        if (iot_typecode_type (requests[i].type) == IOT_DATA_BOOL)
        {
          readings[i].value = iot_data_alloc_bool (rand () % 2 == 1);
        }
        else
        {
          const char *minstr = devsdk_nvpairs_value (requests[i].attributes, "minimum");
          const char *maxstr = devsdk_nvpairs_value (requests[i].attributes, "maximum");
          if (minstr == NULL || maxstr == NULL)
          {
            *exception = iot_data_alloc_string ("random sequence requires \"minimum\" and \"maximum\" attributes", IOT_DATA_REF);
            pthread_mutex_unlock(&driver->mutex);
            return false;
          }
          iot_data_type_t type = iot_typecode_type (requests[i].type);
          iot_data_t *min = iot_data_alloc_from_string (type, minstr);
          iot_data_t *max = iot_data_alloc_from_string (type, maxstr);
          readings[i].value = generateRandom (&driver->rndseed, type, min, max);
          iot_data_free (min);
          iot_data_free (max);
        }
      }
      else
      {
        iot_log_error (driver->lc, "Unknown sequence type %s", seqtype);
        *exception = iot_data_alloc_string ("Unknown sequence type", IOT_DATA_REF);
        pthread_mutex_unlock(&driver->mutex);
        return false;
      }
    }
    else
    {
      iot_data_t *currval = (iot_data_t *)iot_data_string_map_get (device, requests[i].resname);
      if (!currval)
      {
        const char *initial = devsdk_nvpairs_value (requests[i].attributes, "firstValue");
        iot_data_t *newval = iot_data_alloc_from_string (iot_typecode_type (requests[i].type), initial ? initial : "0");
        iot_data_string_map_add (device, requests[i].resname, newval);
        currval = newval;
      }
      readings[i].value = currval;
      iot_data_add_ref (currval);
    }
  }
  pthread_mutex_unlock(&driver->mutex);
  return true;
}

/* ---- Put ---- */
/* Put triggers an asynchronous protocol specific SET operation.
 * The device to set values on is specified by the protocols.
 * nvalues is the number of values to be set and defines the size of the
 * requests and values arrays. For each value, the commandresult holds the
 * value, and the commandrequest holds information as to where it is to be
 * written. The implementation of this method should effect the write to the
 * device.
 *
 * Note - In a commandrequest, the DeviceResource represents a deviceResource
 * which is defined in the device profile.
*/
static bool example_put_handler
(
  void *impl,
  const char *devname,
  const devsdk_protocols *protocols,
  uint32_t nvalues,
  const devsdk_commandrequest *requests,
  const iot_data_t *values[],
  iot_data_t **exception
)
{
  example_driver *driver = (example_driver *) impl;
  /* Access the location of the device to be accessed and log it */
  iot_log_debug (driver->lc, "PUT on device:");
  const devsdk_nvpairs *nvs = devsdk_protocols_properties (protocols, "Other");
  for (const devsdk_nvpairs *nv = nvs; nv; nv = nv->next)
  {
    iot_log_debug (driver->lc, "  %s = %s", nv->name, nv->value);
  }

  pthread_mutex_lock(&driver->mutex);
  iot_data_t *device = getDeviceMap (driver->sequencemap, devname);
  for (uint32_t i = 0; i < nvalues; i++)
  {
    const char *seqtype = devsdk_nvpairs_value (requests[i].attributes, "sequenceType");
    if (seqtype)
    {
      *exception = iot_data_alloc_string ("PUT invalid for sequence data", IOT_DATA_REF);
      pthread_mutex_unlock(&driver->mutex);
      return false;
    }
    else
    {
      iot_data_t *val = (iot_data_t *)values[i];
      iot_data_string_map_add (device, requests[i].resname, val);
      iot_data_add_ref (val);
    }
  }
  pthread_mutex_unlock(&driver->mutex);
  return true;
}

/* ---- Stop ---- */
/* Stop performs any final actions before the device service is terminated */
static void example_stop(void *impl, bool force)
{
  example_driver *driver = (example_driver *) impl;
  pthread_mutex_destroy (&driver->mutex);
  iot_data_free (driver->sequencemap);
}

/* Device Callbacks */
static devsdk_callbacks exampleImpls =
{
  example_init,         /* Initialize */
  NULL,                 /* Discovery */
  example_get_handler,  /* Get */
  example_put_handler,  /* Put */
  example_stop,         /* Stop */
  NULL,                 /* Device added */
  NULL,                 /* Device updated */
  NULL,                 /* Device removed */
  NULL,                 /* Autoevent start */
  NULL                  /* Autoevent stop */
};

static iot_component_t * xrt_example_device_service_config (iot_container_t * cont, const iot_data_t * map)
{
  example_driver * impl = calloc (1, sizeof(example_driver));
  iot_component_t * component = xrt_device_config (cont, map, impl, exampleImpls);
  return component;
}

extern const iot_component_factory_t * xrt_example_device_service_factory (void)
{
  static iot_component_factory_t factory =
  {
    XRT_EXAMPLE_DEVICE_SERVICE_TYPE,
    XRT_CATEGORY_DEVICE_SERVICE,
    xrt_example_device_service_config,
    (iot_component_free_fn_t) xrt_device_free,
    NULL,
    NULL
  };
  return &factory;
}
