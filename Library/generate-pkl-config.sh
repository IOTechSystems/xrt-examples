#!/usr/bin/env bash
# Regenerates deployment/ for a Library/<app> directory from its
# deployment.pkl, using the XRT Pkl deployment schema. Requires:
#   - the `pkl` CLI (https://pkl-lang.org), 0.29 or later
#   - XRT_SRC: an XRT source checkout of the XRT these examples run
#     (v3.4-branch), whose src/pkl/deploy is the XRT Pkl package. It is linked
#     in as Library/xrt-pkl, the local dependency in PklProject. Once set, the
#     link is reused, so XRT_SRC only needs giving again to change it.
#
# xrt-standalone gets its component config (deployment/config) and device
# state (deployment/<service>/state). app1-colocated only gets device state,
# and app2-standalone nothing at all - their component config is compiled in
# from their deployment_config.h instead.
#
# None of the generated files are committed (they're gitignored), so this
# must be run before `docker compose up --build`.
#
# Usage: [XRT_SRC=<xrt checkout>] ./generate-pkl-config.sh [app-directory]
#   e.g.  XRT_SRC=~/xrt ./generate-pkl-config.sh   (all apps)
#         ./generate-pkl-config.sh app1-colocated
#         ./generate-pkl-config.sh app2-standalone
#         ./generate-pkl-config.sh xrt-standalone
set -euo pipefail

if [ $# -gt 1 ]; then
  echo "usage: [XRT_SRC=<xrt checkout>] $0 [app-directory]  (e.g. app1-colocated, app2-standalone, xrt-standalone)" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "${XRT_SRC:-}" ]; then
  if [ ! -f "$XRT_SRC/src/pkl/deploy/PklProject" ]; then
    echo "XRT_SRC=$XRT_SRC is not an XRT source checkout (no src/pkl/deploy/PklProject)" >&2
    exit 1
  fi
  ln -sfn "$(cd "$XRT_SRC/src/pkl/deploy" && pwd)" "$SCRIPT_DIR/xrt-pkl"
elif [ ! -f "$SCRIPT_DIR/xrt-pkl/PklProject" ]; then
  echo "Set XRT_SRC to an XRT source checkout (v3.4-branch), for its Pkl package" >&2
  exit 1
fi

generate () {
  APP_DIR="$(cd "$SCRIPT_DIR/$1" && pwd)"
  rm -rf "$APP_DIR"/deployment/config
  rm -f "$APP_DIR"/deployment/*/state/devices.json "$APP_DIR"/deployment/*/state/schedules.json
  (cd "$APP_DIR" && pkl eval deployment.pkl -m deployment) >/dev/null
  echo "Regenerated $APP_DIR/deployment from deployment.pkl"
}

if [ $# -eq 1 ]; then
  generate "$1"
else
  generate app1-colocated
  generate app2-standalone
  generate xrt-standalone
fi
