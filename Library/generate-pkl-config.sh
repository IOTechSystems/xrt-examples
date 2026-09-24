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
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <app-directory>  (e.g. app1-colocated, xrt-standalone)" >&2
  exit 1
fi

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/$1" && pwd)"

rm -f "$APP_DIR"/deployment/config/*.json
(cd "$APP_DIR" && pkl eval deployment.pkl -m deployment) >/dev/null

echo "Regenerated $APP_DIR/deployment/config from deployment.pkl"
