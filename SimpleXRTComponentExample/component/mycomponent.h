
#ifndef _XRT_EXAMPLE_DEVICE_SERVICE_H_
#define _XRT_EXAMPLE_DEVICE_SERVICE_H_

#include <iot/component.h>
#include <iot/iot.h>

#ifdef __cplusplus
extern "C" {
#endif

#define MY_COMPONENT_TYPE "IOT::MyComponent"

extern const iot_component_factory_t * mycomponent_factory (void);

#ifdef __cplusplus
}
#endif
#endif