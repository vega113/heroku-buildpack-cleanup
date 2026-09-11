#!/usr/bin/env bash
# Non-vacuous: CLEAN_HEROKU=true must preserve the JVM metrics agent jar (#4276).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
BUILD_DIR="$TMP/build"
CACHE_DIR="$TMP/cache"
ENV_DIR="$TMP/env"
mkdir -p "$BUILD_DIR/.heroku/bin" "$CACHE_DIR" "$ENV_DIR"
echo fake-agent > "$BUILD_DIR/.heroku/bin/heroku-metrics-agent.jar"
echo other > "$BUILD_DIR/.heroku/other-file"
export CLEAN_HEROKU=true
bash "$ROOT/bin/compile" "$BUILD_DIR" "$CACHE_DIR" "$ENV_DIR"
test -f "$BUILD_DIR/.heroku/bin/heroku-metrics-agent.jar"
test ! -f "$BUILD_DIR/.heroku/other-file"
echo "compile.test.sh OK"
