# github.com/tiredofit/docker-freescout

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-freescout?style=flat-square)](https://github.com/tiredofit/docker-freescout/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-freescout/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-freescout/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/freescout.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/freescout/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/freescout.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/freescout/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *
## About

This will build a Docker Image for [Freescout](https://freescout.net/) - An open source Helpscout / Zendesk alternative.

* Automatically installs and sets up installation upon first start

## Maintainer

- [Dave Conroy](https://github.com/tiredofit)

## Table of Contents


- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Prerequisites and Assumptions](#prerequisites-and-assumptions)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)

## Prerequisites and Assumptions
*  Assumes you are using some sort of SSL terminating reverse proxy such as:
   *  [Traefik](https://github.com/tiredofit/docker-traefik)
   *  [Nginx](https://github.com/jc21/nginx-proxy-manager)
   *  [Caddy](https://github.com/caddyserver/caddy)
*  Requires access to a MySQL/MariaDB or Postgres Server

## Installation

### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/freescout)

```bash
docker pull docker.io/tiredofit/freescout:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-freescout/pkgs/container/docker-freescout)

```
docker pull ghcr.io/tiredofit/docker-freescout:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

## Configuration

### Quick Start

- The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

- Set various [environment variables](#environment-variables) to understand the capabilities of this image.
- Map [persistent storage](#data-volumes) for access to configuration and data files for backup.
- Make [networking ports](#networking) available for public access if necessary

**The first boot can take from 2 minutes - 5 minutes depending on your CPU to setup the proper schemas.**

- Login to the web server and enter in your admin email address, admin password and start configuring the system!

### Persistent Storage
The following directories are used for configuration and can be mapped for persistent storage.

| Directory                | Description                                                                                                              |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `/www/logs`              | Nginx and PHP Log files                                                                                                  |
| `/assets/custom`         | (Optional) Copy source code over existing source code in /www/html upon container start. Use exact file/folder structure |
| `/assets/custom-scripts` | (Optional) If you want to execute custom scripting, place scripts here with extension `.sh`                              |
| `/assets/modules`        | (Optional) If you want to add additional modules outside of the source tree, add them here                               |
| `/www/html`              | (Optional) If you want to expose the Freescout sourcecode and enable Self Updating, expose this volume                   |
| *OR*                     |                                                                                                                          |
| `/data`                  | Hold onto your persistent sessions and cache between container restarts                                                  |

### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) or [Debian Linux](https://hub.docker.com/r/tiredofit/debian) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                         | Description                            |
| ------------------------------------------------------------- | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/)        | Customized Image based on Alpine Linux |
| [Nginx](https://github.com/tiredofit/docker-nginx/)           | Nginx webserver                        |
| [PHP-FPM](https://github.com/tiredofit/docker-nginx-php-fpm/) | PHP Interpreter                        |


| Parameter                  | Description                                                                                     | Default     | `_FILE` |
| -------------------------- | ----------------------------------------------------------------------------------------------- | ----------- | ------- |
| `ADMIN_EMAIL`              | Administrator Email Address - Needed for logging in                                             |             | x       |
| `ADMIN_FIRST_NAME`         | Admin user First Name                                                                           | `Admin`     | x       |
| `ADMIN_LAST_NAME`          | Admin user First Name                                                                           | `User`      | x       |
| `ADMIN_PASS`               | Administrator Password - Needed for Logging in                                                  |             | x       |
| `APPLICATION_NAME`         | Change default application name - Default `Freescout`                                           | `freescout` |         |
| `APP_PROXY`                | Allow Application to use a proxy for fetching modules                                           |             |         |
| `APP_NEW_FETCHING_LIBRARY` | Sets FreeScout's new_fetching_library config option                                             | `FALSE`     |         |
| `DB_TYPE`                  | Type of the Database. Currently supported are `mysql` and `pgsql`                               | `mysql`     |         |
| `DB_PGSQL_SSL_MODE`        | Postgresql TLS Mode                                                                             | `prefer`    |         |
| `DB_HOST`                  | Host or container name of the Databse Server e.g. `freescout-db`                                |             | x       |
| `DB_PORT`                  | Database Port e.g.`3306` for mysql, `5432` for postgres                                         | `3306`      | x       |
| `DB_NAME`                  | Database name e.g. `freescout`                                                                  |             | x       |
| `DB_USER`                  | Username for above Database e.g. `freescout`                                                    |             | x       |
| `DB_PASS`                  | Password for above Database e.g. `password`                                                     |             | x       |
| `DISPLAY_ERRORS`           | Display Errors on Website                                                                       | `FALSE`     |         |
| `ENABLE_AUTO_UPDATE`       | If coming from an earlier version of image, automatically update it to latest Freescout release | `TRUE`      |         |
| `SETUP_TYPE`               | Automatically edit configuration after first bootup `AUTO` or `MANUAL`                          | `AUTO`      |         |
| `SITE_URL`                 | The url your site listens on example `https://freescout.example.com`                            |             |         |


### Networking

The following ports are exposed.

| Port | Description |
| ---- | ----------- |
| `80` | HTTP        |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://freescout.net/>
* <https://github.com/freescout-helpdesk/freescout/wiki/Installation-Guide>
