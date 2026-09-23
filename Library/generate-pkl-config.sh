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
# numeric prefix (e.g. "bus" -> "08-bus") for both the filename and the
# component's own registered id - and that prefixed id, not the plain
# name, is what iot_container_init() registers the component under at
# runtime (confirmed in iotech-c-utils' container.c). Since our own C code
# (spg_demo.c) and every config's own cross-references expect plain names
# ("bus", "logger", "spgapp_pool", ...), strip the "<digits>-" prefix from
# every filename, from main.json's keys, and from any string value
# elsewhere that exactly matches one of those prefixed keys (every
# cross-reference in this schema's output is always the full prefixed
# string as a JSON value, never partial/embedded, so a plain dict
# replacement is safe).
python3 - "$TMP_OUT/config" "$APP_DIR/deployment/config" <<'PYEOF'
import json
import re
import sys
import pathlib

src, dst = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
prefix_re = re.compile(r"^\d+-")

main = json.loads((src / "main.json").read_text())
rename = {pid: prefix_re.sub("", pid) for pid in main}


def fix(value):
    if isinstance(value, dict):
        return {k: fix(v) for k, v in value.items()}
    if isinstance(value, list):
        return [fix(v) for v in value]
    if isinstance(value, str) and value in rename:
        return rename[value]
    return value


dst.mkdir(parents=True, exist_ok=True)
for old in dst.glob("*.json"):
    old.unlink()

new_main = {rename[pid]: typ for pid, typ in main.items()}
(dst / "main.json").write_text(json.dumps(new_main, indent=2) + "\n")

for pid, new_name in rename.items():
    data = fix(json.loads((src / f"{pid}.json").read_text()))
    (dst / f"{new_name}.json").write_text(json.dumps(data, indent=2) + "\n")
PYEOF

echo "Regenerated $APP_DIR/deployment/config from deployment.pkl"
