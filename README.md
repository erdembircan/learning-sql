<p align="center">
  <img src="https://learning.oreilly.com/library/cover/9781492057604/250w/" alt="Learning SQL, 3rd Edition" />
</p>

# Learning SQL

Practice environment for [*Learning SQL, 3rd Edition*](https://www.amazon.com/Learning-SQL-Generate-Manipulate-Retrieve/dp/1492057614) by Alan Beaulieu. Runs MySQL (latest) with the [Sakila sample database](https://dev.mysql.com/doc/sakila/en/) in Docker.

## Quick start

```bash
./start.sh        # downloads Sakila, starts MySQL, connects
./start.sh --vim  # same as above, with vim keybindings in the MySQL prompt
./start.sh --web  # starts MySQL + Adminer, prints the web UI URL
./stop.sh         # stops the container
./reset.sh        # removes everything (containers, volumes, images, downloaded files)
```

`start.sh` is all you need — it downloads the Sakila database on first run, starts the Docker container, waits for MySQL to be ready, and drops you into a `mysql` shell connected to the `sakila` database. Use `--web` to launch [Adminer](https://www.adminer.org/) instead, a lightweight browser-based database UI. Use `reset.sh` to start completely fresh.

## Environment

The `.env` file is the single source of truth for MySQL credentials and database name. Both `docker-compose.yml` and `start.sh` read from it.

| Variable             | Default | Description            |
| -------------------- | ------- | ---------------------- |
| `MYSQL_ROOT_PASSWORD`| `root`  | MySQL root password    |
| `MYSQL_DATABASE`     | `sakila`| Default database name  |
| `ADMINER_PORT`       | `8080`  | Adminer web UI port    |

## Requirements

- Docker & Docker Compose
