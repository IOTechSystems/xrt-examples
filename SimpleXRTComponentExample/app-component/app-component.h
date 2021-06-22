
#ifndef _XRT_EXAMPLE_DEVICE_SERVICE_H_
#define _XRT_EXAMPLE_DEVICE_SERVICE_H_

#include <iot/iot.h>
#include "xrt/bus.h"

#ifdef __cplusplus
extern "C" {
#endif

// the value of the component type has to match in the value entered in the app_component.json and main.json files
#define APP_COMPONENT_TYPE "XRT::ApplicationComponent"

extern const iot_component_factory_t * app_component_factory (void);

#ifdef __cplusplus
}
#endif
#endif