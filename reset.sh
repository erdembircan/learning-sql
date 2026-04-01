#!/usr/bin/env bash
set -eo pipefail

cd "$(dirname "$0")"

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
RED='\033[31m'
DIM='\033[2m'
RESET='\033[0m'

# Spinner
SPINNER_PID=""
spin() {
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local msg="$1"
  while true; do
    for f in "${frames[@]}"; do
      printf "\r${CYAN}%s${RESET} ${DIM}%s${RESET}" "$f" "$msg"
      sleep 0.08
    done
  done
}
ERR_LOG=$(mktemp)
start_spinner() { CURRENT_STEP="$1"; spin "$1" & SPINNER_PID=$!; }
stop_spinner()  { kill "$SPINNER_PID" 2>/dev/null; wait "$SPINNER_PID" 2>/dev/null || true; printf "\r\033[K${GREEN}✔${RESET} %s\n" "$1"; SPINNER_PID=""; }
fail_spinner()  { kill "$SPINNER_PID" 2>/dev/null; wait "$SPINNER_PID" 2>/dev/null || true; printf "\r\033[K${RED}✖${RESET} %s\n" "$1"; SPINNER_PID=""; }
cleanup() {
  [ -n "$SPINNER_PID" ] && fail_spinner "$CURRENT_STEP"
  [ -s "$ERR_LOG" ] && printf "  %s\n" "$(cat "$ERR_LOG")"
  rm -f "$ERR_LOG"
}
trap cleanup EXIT

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
