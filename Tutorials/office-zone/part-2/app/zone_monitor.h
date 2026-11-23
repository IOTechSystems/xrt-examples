/*
 * Copyright (c) 2026
 * IOTech Ltd
 *
 * Zone monitor: a Sparkplug application, packaged as an XRT component, that
 * watches the office zone published by the Xrt node from Part 1 and switches
 * the fan on when the zone is too warm.
 */

#ifndef _ZONE_MONITOR_H_
#define _ZONE_MONITOR_H_

#include "iot/component.h"

#define ZONE_MONITOR_TYPE "App::ZoneMonitor"

extern const iot_component_factory_t *zone_monitor_factory (void);

#endif
