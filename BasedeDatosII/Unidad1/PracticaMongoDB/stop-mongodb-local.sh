#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
MONGOD="$ROOT_DIR/tools/mongodb-macos-aarch64--8.0.26/bin/mongod"

"$MONGOD" --dbpath "$ROOT_DIR/data/db" --shutdown || true

echo "MongoDB detenido."
