# Learning SQL

Practice environment for *Learning SQL, 3rd Edition* by Alan Beaulieu. Runs MySQL 8.0 with the [Sakila sample database](https://dev.mysql.com/doc/sakila/en/) in Docker.

## Quick start

```bash
./start.sh   # downloads Sakila, starts MySQL, connects
./stop.sh    # stops the container
./reset.sh   # removes everything (containers, volumes, images, downloaded files)
```

`start.sh` is all you need — it downloads the Sakila database on first run, starts the Docker container, waits for MySQL to be ready, and drops you into a `mysql` shell connected to the `sakila` database. Use `reset.sh` to start completely fresh.

## Requirements

- Docker & Docker Compose
