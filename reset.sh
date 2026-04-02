#!/usr/bin/env bash
set -eo pipefail

cd "$(dirname "$0")"
source lib/spinner.sh

# Remove containers, volumes, images, and orphans
start_spinner "Removing containers, volumes, and images"
docker compose down -v --rmi all --remove-orphans >/dev/null 2>"$ERR_LOG"
stop_spinner "Docker resources removed"

# Remove downloaded Sakila database
if [ -d "sakila-db" ]; then
  start_spinner "Removing Sakila database files"
  rm -rf sakila-db
  stop_spinner "Sakila database files removed"
fi
