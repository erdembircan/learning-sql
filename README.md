# Learning SQL

Practice environment for *Learning SQL, 3rd Edition* by Alan Beaulieu. Runs MySQL 8.0 with the [Sakila sample database](https://dev.mysql.com/doc/sakila/en/) in Docker.

## Quick start

```bash
./start.sh   # downloads Sakila, starts MySQL, connects
./stop.sh    # stops the container
```

`start.sh` is all you need — it downloads the Sakila database on first run, starts the Docker container, waits for MySQL to be ready, and drops you into a `mysql` shell connected to the `sakila` database.

## Requirements

- Docker & Docker Compose
