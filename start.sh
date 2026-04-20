#!/usr/bin/env bash
set -eo pipefail

cd "$(dirname "$0")"
source lib/spinner.sh
source .env

VIM_MODE=false
WEB_MODE=false
for arg in "$@"; do
  case "$arg" in
    --vim) VIM_MODE=true ;;
    --web) WEB_MODE=true ;;
  esac
done

# Generate .my.cnf from environment variables
cat > .my.cnf <<EOF
[mysql]
user=root
password=${MYSQL_ROOT_PASSWORD}
database=${MYSQL_DATABASE}

[mysqladmin]
user=root
password=${MYSQL_ROOT_PASSWORD}
EOF

# Download Sakila sample database if not present
if [ ! -d "sakila-db" ]; then
  start_spinner "Downloading Sakila sample database"
  curl -sSfL https://downloads.mysql.com/docs/sakila-db.tar.gz 2>"$ERR_LOG" | tar xz 2>"$ERR_LOG"
  mv sakila-db/sakila-schema.sql sakila-db/01-sakila-schema.sql
  mv sakila-db/sakila-data.sql sakila-db/02-sakila-data.sql
  cp extras/03-chapter12.sql sakila-db/03-chapter12.sql
  cp extras/04-chapter16.sql sakila-db/04-chapter16.sql
  stop_spinner "Sakila sample database downloaded"
fi

# Start the container
if [[ "$WEB_MODE" == true ]]; then
  start_spinner "Starting MySQL and Adminer containers"
  docker compose up -d mysql adminer >/dev/null 2>&1
  stop_spinner "MySQL and Adminer containers started"
else
  start_spinner "Starting MySQL container"
  docker compose up -d mysql >/dev/null 2>"$ERR_LOG"
  stop_spinner "MySQL container started"
fi

# Wait for MySQL to be fully ready (ping succeeds before init scripts finish)
start_spinner "Waiting for MySQL to be ready"
until docker compose exec mysql mysql -e "SELECT 1" >/dev/null 2>&1; do
  sleep 2
done
stop_spinner "MySQL is ready"

echo ""
if [[ "$WEB_MODE" == true ]]; then
  echo "Adminer is running at http://localhost:${ADMINER_PORT}"
  echo "Server: mysql | User: root | Password: ${MYSQL_ROOT_PASSWORD} | Database: ${MYSQL_DATABASE}"
elif [[ "$VIM_MODE" == true ]]; then
  docker compose exec mysql rlwrap -a mysql
else
  docker compose exec mysql mysql
fi
