/*
 * Copyright (c) 2018-2021
 * IoTech Ltd
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 */

#ifndef _XRT_EXAMPLE_DEVICE_SERVICE_H_
#define _XRT_EXAMPLE_DEVICE_SERVICE_H_

#include <iot/component.h>

#ifdef __cplusplus
extern "C" {
#endif

#define XRT_EXAMPLE_DEVICE_SERVICE_TYPE "XRT::ExampleDeviceService"

extern const iot_component_factory_t * xrt_example_device_service_factory (void);

#ifdef __cplusplus
}
#endif
#endif

