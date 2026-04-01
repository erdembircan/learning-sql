#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
DIM='\033[2m'
RESET='\033[0m'

# Spinner — runs in background, call stop_spinner to clean up
SPINNER_PID=""
spin() {
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local msg="$1"
  while true; do
    for f in "${frames[@]}"; do
      printf "\r  ${CYAN}%s${RESET} ${DIM}%s${RESET}" "$f" "$msg"
      sleep 0.08
    done
  done
}
start_spinner() { spin "$1" & SPINNER_PID=$!; }
stop_spinner()  { kill "$SPINNER_PID" 2>/dev/null; wait "$SPINNER_PID" 2>/dev/null || true; printf "\r\033[K  ${GREEN}✔${RESET} %s\n" "$1"; SPINNER_PID=""; }

# Download Sakila sample database if not present
if [ ! -d "sakila-db" ]; then
  start_spinner "Downloading Sakila sample database"
  curl -sL https://downloads.mysql.com/docs/sakila-db.tar.gz | tar xz
  mv sakila-db/sakila-schema.sql sakila-db/01-sakila-schema.sql
  mv sakila-db/sakila-data.sql sakila-db/02-sakila-data.sql
  stop_spinner "Sakila sample database downloaded"
fi

# Start the container
start_spinner "Starting MySQL container"
docker compose up -d &>/dev/null
stop_spinner "MySQL container started"

# Wait for MySQL to be fully ready (ping succeeds before init scripts finish)
start_spinner "Waiting for MySQL to be ready"
until docker compose exec mysql mysql -uroot -proot -e "SELECT 1" &>/dev/null; do
  sleep 2
done
stop_spinner "MySQL is ready"

echo ""
docker compose exec mysql mysql -uroot -proot sakila
