#!/usr/bin/env bash
set -x
set -euo pipefail

if command -v desktop_ready >/dev/null 2>&1; then
  desktop_ready || true
fi

if [[ -n "${APP_CMD:-}" ]]; then
  bash -lc "${APP_CMD}" >/proc/1/fd/1 2>/proc/1/fd/2 &
fi

tail -f /dev/null
