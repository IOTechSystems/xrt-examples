#!/bin/sh
# Packages the opcua source plugin in opcua-source/ and installs it into the running eKuiper
# container. The plugin subscribes to Sparkplug metrics through the Alarm Service's OPC UA Server.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZIP="$SCRIPT_DIR/opcua.zip"

rm -f "$ZIP"
(cd "$SCRIPT_DIR/opcua-source" && python3 -m zipfile -c "$ZIP" opcua.py opcua.json install.sh sources)

docker cp "$ZIP" ekuiper:/tmp/opcua.zip

# Remove any previously installed version
curl -s -X DELETE http://localhost:59720/plugins/portables/opcua >/dev/null 2>&1 || true
sleep 2

curl -sf -X POST http://localhost:59720/plugins/portables \
  -H 'Content-Type: application/json' \
  -d '{"name": "opcua", "file": "file:///tmp/opcua.zip"}'
echo
