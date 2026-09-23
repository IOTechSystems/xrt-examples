#!/usr/bin/env bash
# Regenerates deployment/config for a Library/<app> directory from its
# deployment.pkl, using the XRT Pkl deployment schema. Requires:
#   - the `pkl` CLI (https://pkl-lang.org)
#   - a sibling checkout of https://github.com/IOTechSystems/xrt at
#     ../../xrt (relative to this script), on XRT-3877-branch - this
#     schema (src/pkl/deploy) isn't merged into XRT's default branch yet.
#
# Usage: ./generate-pkl-config.sh <app-directory>
#   e.g.  ./generate-pkl-config.sh app1-colocated
#         ./generate-pkl-config.sh xrt-standalone
#
# Only deployment/config/ is (re)written. deployment/state/ (devices.json,
# schedules.json, profiles/) is left untouched and must still be edited by
# hand - see the comment at the top of each app's deployment.pkl for why
# (a schema bug drops every field but "name" from generated device
# entries, so it's not usable for that yet).
#
# Requires the ThreadPool `threads` null-default fix from XRT-3877-branch
# (core/XRT.pkl: threads defaults to null, and update() only auto-computes
# it when null) - without that fix, an explicit `threads = N` on a pool
# like spgapp_pool gets silently overwritten back to 0.
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <app-directory>  (e.g. app1-colocated, xrt-standalone)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd "$SCRIPT_DIR/$1" && pwd)"

if [ ! -f "$APP_DIR/deployment.pkl" ]; then
  echo "error: $APP_DIR/deployment.pkl not found" >&2
  exit 1
fi

TMP_OUT="$(mktemp -d)"
trap 'rm -rf "$TMP_OUT"' EXIT

(cd "$APP_DIR" && pkl eval deployment.pkl -m "$TMP_OUT") >/dev/null

# NodeConfig.deployment() (core/XRT.pkl) relabels every component with a
# numeric prefix (e.g. "bus" -> "08-bus"), for both the filename and the
# component's own registered id in main.json. That's not just cosmetic:
# iot_container_init() (iotech-c-utils' container.c) loads main.json into a
# sorted map, so the prefix is what makes its key order (alphabetical)
# match real dependency order - stripping it here would throw that
# load-order guarantee away. So this now copies the generated config
# through unchanged; any C code that needs a plain component name (e.g.
# spg_demo.c's "bus"/"logger"/"spgapp_pool" lookups) resolves the real,
# still-prefixed id itself at startup instead.
DST="$APP_DIR/deployment/config"
mkdir -p "$DST"
find "$DST" -maxdepth 1 -name '*.json' -delete
cp "$TMP_OUT/config/"*.json "$DST/"

echo "Regenerated $APP_DIR/deployment/config from deployment.pkl"
