#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Download Sakila sample database if not present
if [ ! -d "sakila-db" ]; then
  echo "Downloading Sakila sample database..."
  curl -sL https://downloads.mysql.com/docs/sakila-db.tar.gz | tar xz
  # Prefix files so schema loads before data (docker-entrypoint-initdb.d runs alphabetically)
  mv sakila-db/sakila-schema.sql sakila-db/01-sakila-schema.sql
  mv sakila-db/sakila-data.sql sakila-db/02-sakila-data.sql
  echo "Done."
fi

# Start the container
echo "Starting MySQL container..."
docker compose up -d

# Wait for MySQL to be fully ready (ping succeeds before init scripts finish)
echo "Waiting for MySQL to be ready..."
until docker compose exec mysql mysql -uroot -proot -e "SELECT 1" &>/dev/null; do
  sleep 2
done

echo "Connecting to MySQL (sakila database)..."
echo ""
docker compose exec mysql mysql -uroot -proot sakila
