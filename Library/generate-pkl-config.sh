#!/usr/bin/env bash
# Regenerates deployment/ for a Library/<app> directory from its
# deployment.pkl, using the XRT Pkl deployment schema. Requires:
#   - the `pkl` CLI (https://pkl-lang.org)
#   - a sibling checkout of https://github.com/IOTechSystems/xrt at
#     ../../xrt (relative to this script), on v3.4-branch (the schema lives
#     in src/pkl/deploy).
#
# xrt-standalone gets its component config (deployment/config) and device
# state (devices/schedules under deployment/state). app1-colocated only gets
# device state - its component config is compiled in from
# app1-colocated/deployment_config.h instead.
#
# None of the generated files are committed (they're gitignored), so this
# must be run before `docker compose up --build`.
#
# Usage: ./generate-pkl-config.sh [app-directory]
#   e.g.  ./generate-pkl-config.sh                 (all apps)
#         ./generate-pkl-config.sh app1-colocated
#         ./generate-pkl-config.sh xrt-standalone
set -euo pipefail

if [ $# -gt 1 ]; then
  echo "usage: $0 [app-directory]  (e.g. app1-colocated, xrt-standalone)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

generate () {
  APP_DIR="$(cd "$SCRIPT_DIR/$1" && pwd)"
  rm -rf "$APP_DIR"/deployment/config
  rm -f "$APP_DIR"/deployment/state/*/devices.json "$APP_DIR"/deployment/state/*/schedules.json
  (cd "$APP_DIR" && pkl eval deployment.pkl -m deployment) >/dev/null
  echo "Regenerated $APP_DIR/deployment from deployment.pkl"
}

if [ $# -eq 1 ]; then
  generate "$1"
else
  generate app1-colocated
  generate xrt-standalone
fi
