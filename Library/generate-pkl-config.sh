#!/usr/bin/env bash
# Regenerates deployment/ for a Library/<app> directory from its
# deployment.pkl, using the XRT Pkl deployment schema. Requires:
#   - the `pkl` CLI (https://pkl-lang.org), 0.29 or later
#   - network access to iotech.jfrog.io, where the XRT Pkl package (the
#     version in PklProject) is downloaded from on first use.
#
# xrt-standalone gets its component config (deployment/config) and device
# state (deployment/<service>/state). app1-colocated and app2-standalone get
# their component config as deployment_config.h instead, compiled into the
# app, and app1-colocated its device state.
#
# None of the generated files are committed (they're gitignored), so this
# must be run before `docker compose up --build`.
#
# Usage: ./generate-pkl-config.sh [app-directory]
#   e.g.  ./generate-pkl-config.sh   (all apps)
#         ./generate-pkl-config.sh app1-colocated
#         ./generate-pkl-config.sh app2-standalone
#         ./generate-pkl-config.sh xrt-standalone
set -euo pipefail

if [ $# -gt 1 ]; then
  echo "usage: $0 [app-directory]  (e.g. app1-colocated, app2-standalone, xrt-standalone)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Resolve PklProject's dependencies into PklProject.deps.json
(cd "$SCRIPT_DIR" && pkl project resolve) >/dev/null

generate () {
  APP_DIR="$(cd "$SCRIPT_DIR/$1" && pwd)"
  rm -rf "$APP_DIR"/deployment/config
  rm -f "$APP_DIR"/deployment_config.h "$APP_DIR"/deployment/*/state/devices.json "$APP_DIR"/deployment/*/state/schedules.json
  (cd "$APP_DIR" && pkl eval deployment.pkl -m .) >/dev/null
  echo "Regenerated $APP_DIR/deployment from deployment.pkl"
}

if [ $# -eq 1 ]; then
  generate "$1"
else
  generate app1-colocated
  generate app2-standalone
  generate xrt-standalone
fi
