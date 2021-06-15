
#ifndef _XRT_EXAMPLE_DEVICE_SERVICE_H_
#define _XRT_EXAMPLE_DEVICE_SERVICE_H_

#include <iot/iot.h>
#include "xrt/bus.h"

#ifdef __cplusplus
extern "C" {
#endif

// name of MyComponent has to match in the mycomponent.json and main.json files
#define MY_COMPONENT_TYPE "XRT::MyComponent"

extern const iot_component_factory_t * my_component_factory (void);

#ifdef __cplusplus
}
#endif
#endif