#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MONGOD="$ROOT_DIR/tools/mongodb-macos-aarch64--8.0.26/bin/mongod"

mkdir -p "$ROOT_DIR/data/db" "$ROOT_DIR/logs" "$ROOT_DIR/run"

"$MONGOD" \
  --dbpath "$ROOT_DIR/data/db" \
  --logpath "$ROOT_DIR/logs/mongod.log" \
  --fork \
  --bind_ip 127.0.0.1 \
  --port 37017 \
  --nounixsocket

echo "MongoDB iniciado en mongodb://127.0.0.1:37017"
echo "Log: $ROOT_DIR/logs/mongod.log"
