#!/usr/bin/env bash
set -eo pipefail

cd "$(dirname "$0")"
source lib/spinner.sh

start_spinner "Stopping MySQL container"
docker compose stop >/dev/null 2>"$ERR_LOG"
stop_spinner "MySQL container stopped"
