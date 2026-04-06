#!/usr/bin/env bash
set -eo pipefail

cd "$(dirname "$0")"
source lib/spinner.sh
source .env

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
  stop_spinner "Sakila sample database downloaded"
fi

# Start the container
start_spinner "Starting MySQL container"
docker compose up -d >/dev/null 2>"$ERR_LOG"
stop_spinner "MySQL container started"

# Wait for MySQL to be fully ready (ping succeeds before init scripts finish)
start_spinner "Waiting for MySQL to be ready"
until docker compose exec mysql mysql -e "SELECT 1" >/dev/null 2>&1; do
  sleep 2
done
stop_spinner "MySQL is ready"

echo ""
docker compose exec mysql mysql
