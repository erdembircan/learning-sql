#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Colors
CYAN='\033[36m'
GREEN='\033[32m'
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
start_spinner() { spin "$1" & SPINNER_PID=$!; }
stop_spinner()  { kill "$SPINNER_PID" 2>/dev/null; wait "$SPINNER_PID" 2>/dev/null || true; printf "\r\033[K${GREEN}✔${RESET} %s\n" "$1"; SPINNER_PID=""; }

start_spinner "Stopping MySQL container"
docker compose stop &>/dev/null
stop_spinner "MySQL container stopped"
