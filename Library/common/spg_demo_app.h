/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Demo Sparkplug application, packaged as an XRT component in the same way
 * as XRT's own OPC UA server (XRT::OPCUAServer): the container hands it a
 * Bus, ThreadPool and Logger from its config, and everything else is done
 * through the xrt_spg_app API layered on top of that bus.
 */

#ifndef _SPG_DEMO_APP_H_
#define _SPG_DEMO_APP_H_

#include "iot/component.h"

#define SPG_DEMO_APP_TYPE "App::SparkplugDemo"

extern const iot_component_factory_t *spg_demo_app_factory (void);

#endif
