# nfrastack/container-freescout

## About

This repository will build a container image for running [FreeScout](https://freescout.net/) - an open source [Help Scout](https://www.helpscout.com/) / [Zendesk](https://www.zendesk.com/) alternative for shared inboxes, helpdesk, and ticketing.

## Maintainer

* [Nfrastack](https://www.nfrastack.com)

## Table of Contents

* [About](#about)
* [Maintainer](#maintainer)
* [Table of Contents](#table-of-contents)
* [Installation](#installation)
  * [Prebuilt Images](#prebuilt-images)
  * [Quick Start](#quick-start)
  * [Persistent Storage](#persistent-storage)
* [Upgrading from 1.x](#upgrading-from-1x)
* [Configuration](#configuration)
  * [Environment Variables](#environment-variables)
    * [Base Images used](#base-images-used)
    * [Core Configuration](#core-configuration)
    * [Database](#database)
    * [Application](#application)
    * [Setting FreeScout configuration](#setting-freescout-configuration)
    * [Scheduler](#scheduler)
  * [Networking](#networking)
* [Maintenance](#maintenance)
  * [Shell Access](#shell-access)
* [Support & Maintenance](#support--maintenance)
* [License](#license)
* [References](#references)

## Installation

### Prebuilt Images

Builds are available on the [Github Container Registry](https://github.com/nfrastack/container-freescout/pkgs/container/container-freescout) and [Docker Hub](https://hub.docker.com/r/nfrastack/freescout):

```text
ghcr.io/nfrastack/container-freescout:(image_tag)
docker.io/nfrastack/freescout:(image_tag)
```

Image tag syntax is:

`<image>:<optional tag>`

Example:

`docker.io/nfrastack/freescout:latest` or `ghcr.io/nfrastack/container-freescout:2.2.0`

* `latest` will be the most recent commit on the latest PHP version
* An optional `tag` may exist that matches the [CHANGELOG](CHANGELOG.md) - these are the safest

Have a look at the container registries and see what tags are available.

#### Multi-Architecture Support

Images are built for `amd64` by default, with optional support for `arm64` and other architectures.

## Upgrading from 1.x

This section covers upgrading from the **tiredofit/freescout:1.x** image series to the **nfrastack/freescout:2.x** series. The 2.x image is based on a new base image (`nfrastack/laravel`) and introduces breaking changes to volume paths and environment variables.

### Back up everything

* Dump your database

   If you are running MariaDB/MySQL:

   ```bash
   docker exec freescout-db mysqldump -u freescout -pfreescoutpass freescout > freescout-backup-$(date +%F).sql
   ```

* Copy your data volume to a safe location before any container changes.

### Stop the running container

```bash
docker compose down
```

### Update the image reference

The image has moved. Replace the old image name with the new one in your compose file or whatever you use to orchestrate your stacks.

| Old (1.x)                              | New (2.x)                                      |
| -------------------------------------- | ---------------------------------------------- |
| `docker.io/tiredofit/freescout:latest` | `docker.io/nfrastack/freescout:latest`         |
| `ghcr.io/tiredofit/docker-freescout`   | `ghcr.io/nfrastack/container-freescout:latest` |

Refer to the tagging information in the README.

### Update volume mounts

The log path changed. If you have `/www/logs` mapped, remap it to `/logs`:

| Old (1.x) mount | New (2.x) mount |
| --------------- | --------------- |
| `/www/logs`     | `/logs`         |

* The `/assets/custom`, `/assets/custom-scripts`, and `/assets/modules` volume mounts **no longer exist**. Remove them from your compose file.
* Your existing `/data` or `/www/html` volume can remain as-is, the container will detect the existing state on first boot.

### Verify the config file layout

In 2.x the `.env`/config file is stored at `/data/config/config` (a file inside a directory), whereas in 1.x it was stored directly as `/data/config` (a plain file).

The container will detect and automatically migrate the old layout on first boot. If the auto-migration did not work, or you want to verify before starting the new container, check the layout on your host:

```bash
# Should print "directory"
stat -c '%F' ./data/config
```

If it prints `regular file` instead, run the manual migration by moving the old file out of the way, create the directory, restore the file inside it:

```bash
mv ./data/config ./data/config.bak
mkdir ./data/config
mv ./data/config.bak ./data/config/config
```

Alternatively, set `CONFIG_PATH=/data` in your compose environment to point the container at the old file location - though the directory layout above is recommended.

### Update environment variables

Most FreeScout application configuration variables that were set directly in 1.x must now carry a `FREESCOUT_` prefix.

These continue to work without a prefix:

| Variable             | Notes                                              |
| -------------------- | -------------------------------------------------- |
| `SETUP_TYPE`         | Unchanged                                          |
| `ADMIN_EMAIL`        | Unchanged                                          |
| `ADMIN_FIRST_NAME`   | Unchanged                                          |
| `ADMIN_LAST_NAME`    | Unchanged                                          |
| `ADMIN_PASS`         | Unchanged                                          |
| `ENABLE_AUTO_UPDATE` | Unchanged                                          |
| `DB_TYPE`            | Unchanged; now also accepts `mariadb` / `postgres` |
| `DB_HOST`            | Unchanged                                          |
| `DB_PORT`            | Unchanged                                          |
| `DB_NAME`            | Unchanged                                          |
| `DB_USER`            | Unchanged                                          |
| `DB_PASS`            | Unchanged                                          |
| `DB_SSL`             | Unchanged                                          |
|                      |

#### Variables that now require the `FREESCOUT_` prefix

If you had any of the following set in 1.x, add `FREESCOUT_` in front of them, there are many, or update your `.env` | `${DATA_PATH}/config/config` manually.

| Old (1.x)                              | New (2.x)                                        |
| -------------------------------------- | ------------------------------------------------ |
| `APPLICATION_NAME`                     | `FREESCOUT_APPLICATION_NAME`                     |
| `APP_PROXY`                            | `FREESCOUT_APP_PROXY`                            |
| `APP_TRUSTED_PROXIES`                  | `FREESCOUT_APP_TRUSTED_PROXIES`                  |
| `APP_SINCE_WITHOUT_QUOTES_ON_FETCHING` | `FREESCOUT_APP_SINCE_WITHOUT_QUOTES_ON_FETCHING` |
| `APP_X_FRAME_OPTIONS`                  | `FREESCOUT_APP_X_FRAME_OPTIONS`                  |
| `DB_PGSQL_SSL_MODE`                    | `FREESCOUT_DB_PGSQL_SSL_MODE`                    |
| `DISPLAY_ERRORS`                       | `FREESCOUT_APP_DEBUG`                            |
| `SITE_URL`                             | `APP_URL`                                        |

#### Variables that have been removed

| Old (1.x)                  | Notes    |
| -------------------------- | -------- |
| `SKIP_STORAGE_PERMISSIONS` | Removed. |

#### Pull the new image and start

```bash
docker compose pull
docker compose up -d
```

* * *

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See [examples/compose.yml](examples/compose.yml) for a working stack you can tailor to your environment.
* Map [persistent storage](#persistent-storage) for access to configuration and data files for backup.
* Set [environment variables](#environment-variables) to control container behavior.

**The first boot can take 2-5 minutes depending on your CPU as the schema is created and assets are warmed.**

### Persistent Storage

The following directories should be mapped for persistent storage. The `/data` mount is recommended - it covers config, sessions, cache, modules in one place. Mounting `/www/html` instead is supported when you want the FreeScout source tree exposed for inspection or self-update.

| Directory   | Description                                                            |
| ----------- | ---------------------------------------------------------------------- |
| `/logs`     | Nginx and PHP log files                                                |
| **Choose**  |                                                                        |
| `/data`     | Persistent state - sessions, cache, uploads, `Modules/`, configuration |
| **OR**      |                                                                        |
| `/www/html` | Expose the FreeScout source tree to the host                           |

When mounting `/www/html` instead of `/data`, the container's config and storage redirections point at ephemeral paths by default. To keep everything under the webroot mount, add these environment variables:

| Variable                     | Description                                               |
| ---------------------------- | --------------------------------------------------------- |
| `ENABLE_CONFIG_REDIRECTION`  | Set to `FALSE` to keep `.env` in `/www/html/.env`         |
| `ENABLE_STORAGE_REDIRECTION` | Set to `FALSE` to keep `storage/` in `/www/html/storage/` |

Without these, config, modules and uploaded files are lost on container restart.

## Configuration

### Environment Variables

This image relies on a customized base image in order to work.
Be sure to view the following repositories to understand all the customizable options:

#### Base Images used

| Image                                                                 | Description         |
| --------------------------------------------------------------------- | ------------------- |
| [OS Base](https://github.com/nfrastack/container-base/)               | Base image          |
| [Nginx](https://github.com/nfrastack/container-nginx/)                | Nginx webserver     |
| [Nginx PHP-FPM](https://github.com/nfrastack/container-nginx-php-fpm) | PHP-FPM interpreter |
| [Laravel](https://github.com/nfrastack/container-laravel)             | Laravel runtime     |

Below is the complete list of available options that can be used to customize your installation.

* Variables showing an 'x' under the `Advanced` column can only be set if the containers advanced functionality is enabled.

#### Core Configuration

| Parameter            | Description                                                                                                          | Default                | `_FILE` |
| -------------------- | -------------------------------------------------------------------------------------------------------------------- | ---------------------- | ------- |
| `SETUP_TYPE`         | `AUTO` writes config, runs migrations, creates the bootstrap admin. `MANUAL` does nothing                            | `AUTO`                 |         |
| `ADMIN_EMAIL`        | Email of the bootstrap admin user (created on a fresh DB only)                                                       | `admin@example.com`    | x       |
| `ADMIN_FIRST_NAME`   | First name of the bootstrap admin                                                                                    | `Admin`                | x       |
| `ADMIN_LAST_NAME`    | Last name of the bootstrap admin                                                                                     | `User`                 | x       |
| `ADMIN_PASS`         | Password of the bootstrap admin                                                                                      | `freescout`            | x       |
| `ENABLE_AUTO_UPDATE` | Auto-upgrade FreeScout source on container restart when image version differs from `${DATA_PATH}/.freescout-version` | `TRUE`                 |         |
| `DATA_PATH`          | Base persistent-data path (sessions, cache, modules, version marker live under here)                                 | `/data/`               |         |
| `CONFIG_PATH`        | Config file (.env file redirection) lives here                                                                       | `${DATA_PATH}/config/` |         |
| `CONFIG_FILE`        | Actual name of config file                                                                                           | `config`               |         |
| `MODULES_PATH`       | Persistent storage for FreeScout `Modules/` directory                                                                | `${DATA_PATH}/Modules` |         |
| `DB_TYPE`            | Database driver: `mysql`, `mariadb`, or `pgsql` / `postgres`                                                         | `mysql`                |         |
| `DB_HOST`            | Hostname or container name of the database server                                                                    |                        | x       |
| `DB_PORT`            | Database port                                                                                                        | `3306`                 | x       |
| `DB_NAME`            | Database name (written to `.env` as `DB_DATABASE`)                                                                   |                        | x       |
| `DB_USER`            | Database username (written to `.env` as `DB_USERNAME`)                                                               |                        | x       |
| `DB_PASS`            | Database password (written to `.env` as `DB_PASSWORD`)                                                               |                        | x       |
| `DB_SSL`             | Enable SSL connectivity (`TRUE` / `FALSE`) for MySQL/MariaDB                                                         | `FALSE`                |         |

#### Application

| Parameter | Description                                                                     | Default | `_FILE` |
| --------- | ------------------------------------------------------------------------------- | ------- | ------- |
| `APP_URL` | Full external URL of the site (e.g. `https://freescout.example.com`). Required. |         |         |

#### Setting FreeScout configuration

FreeScout ships ~80 configuration keys (look inside the running container at `/www/html/.env.example` for a sample, or read the [upstream wiki](https://github.com/freescout-helpdesk/freescout/wiki/)).

Any environment variable starting with `FREESCOUT_` is stripped of that prefix and written into the runtime config:

```yaml
environment:
  - FREESCOUT_APP_PROXY=http://proxy.local:3128
  - FREESCOUT_APP_TRUSTED_PROXIES=10.0.0.0/8
  - FREESCOUT_APP_X_FRAME_OPTIONS=DENY
  - FREESCOUT_APP_LOCALE=en
  - FREESCOUT_APP_TIMEZONE=America/Vancouver
  - FREESCOUT_MAIL_DRIVER=smtp
  - FREESCOUT_MAIL_HOST=postfix-relay
  - FREESCOUT_MAIL_PORT=25
  - FREESCOUT_DB_PGSQL_SSL_MODE=require
```

becomes the following lines in  (`/data/config/config` | `/www/html/.env`:

```dotenv
APP_PROXY=http://proxy.local:3128
APP_TRUSTED_PROXIES=10.0.0.0/8
APP_X_FRAME_OPTIONS=DENY
APP_LOCALE=en
APP_TIMEZONE=America/Vancouver
MAIL_DRIVER=smtp
MAIL_HOST=postfix-relay
MAIL_PORT=25
DB_PGSQL_SSL_MODE=require
```

> Three special values delete the matching `.env` line: `FREESCOUT_FOO=unset`, `FREESCOUT_FOO=null`, `FREESCOUT_FOO=`
>
> Docker secrets: any `FREESCOUT_<KEY>_FILE=/run/secrets/x` is resolved into `FREESCOUT_<KEY>=<contents>` before passthrough.

#### Scheduler & Queue Worker

FreeScout requires `php artisan schedule:run` to fire once per minute for mail fetching, queue dispatching, and report digests. There are two methods, `cron` or `service`.

- Under `cron` it relies on busybox cron timers to execute once per minuter
- Under `service` it relies on two container services:
  - `freescout-worker` - a persistent `queue:work` daemon that processes queued jobs (email sending, etc.).
  - `freescout-scheduler` - fires `schedule:run --no-interaction` every minute.

| Parameter            | Description                                                | Default                 |
| -------------------- | ---------------------------------------------------------- | ----------------------- |
| `SCHEDULER_TYPE`     | `service` (S6 loop) or `cron` (crontab). `alt` is an alias | `service`               |
| `SCHEDULER_LOG_TYPE` | Scheduler log type `file` `console` `none`                 | `file`                  |
| `SCHEDULER_LOG_PATH` | Scheduler log path                                         | `${LOG_PATH}`           |
| `SCHEDULER_LOG_FILE` | Scheduler log file name                                    | `scheduler.log`         |
| `WORKER_LOG_PATH`    | Worker log path                                            | `${LOG_PATH}`           |
| `WORKER_LOG_TYPE`    | Worker log type                                            | `${SCHEDULER_LOG_TYPE}` |
| `WORKER_LOG_FILE`    | Worker log file name                                       | `queue-worker.log`      |


### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

* * *

## Maintenance

### Shell Access

For debugging and maintenance, `bash` and `sh` are available in the container. An `artisan` shell function is preinstalled and runs as the nginx user against `/www/html/artisan`.

```bash
docker exec -it freescout-app bash
artisan tinker
```

## Support & Maintenance

* For community help, tips, and discussions, visit the [Discussions board](/discussions).
* For personalized support or a support agreement, see [Nfrastack Support](https://nfrastack.com/).
* To report bugs, submit a [Bug Report](issues/new). Usage questions will be closed as not-a-bug.
* Feature requests are welcome but not guaranteed.
* Updates are best-effort, with priority given to active production use and support agreements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

* <https://freescout.net/>
* <https://github.com/freescout-helpdesk/freescout/wiki>
* <https://github.com/freescout-helpdesk/freescout/wiki/Configuration>
