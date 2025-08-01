ARG PHP_VERSION=8.3
ARG DISTRO="alpine"

FROM docker.io/tiredofit/nginx-php-fpm:${PHP_VERSION}-${DISTRO}-7.7.19
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG FREESCOUT_VERSION

ENV FREESCOUT_VERSION=${FREESCOUT_VERSION:-"1.8.190"} \
    FREESCOUT_REPO_URL=https://github.com/freescout-helpdesk/freescout \
    NGINX_WEBROOT=/www/html \
    NGINX_SITE_ENABLED=freescout \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GNUPG=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IGBINARY=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_INTL=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_PCNTL=TRUE \
    PHP_ENABLE_PDO_PGSQL=TRUE \
    PHP_ENABLE_POSIX=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    IMAGE_NAME="tiredofit/freescout" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-freescout/"

ADD build-assets /build-assets

RUN source /assets/functions/00-container && \
    set -x && \
    package update && \
    package upgrade && \
    package install .freescout-run-deps \
                expect \
                git \
                gnu-libiconv \
                sed \
                && \
    \
    php-ext prepare && \
    php-ext reset && \
    php-ext enable core && \
    php-ext enable core && \
    clone_git_repo ${FREESCOUT_REPO_URL} ${FREESCOUT_VERSION} /assets/install && \
    mkdir -p vendor/natxet/cssmin/src && \
    mkdir -p vendor/rap2hpoutre/laravel-log-viewer/src/controllers && \
    if [ -d "/build-assets/src" ] ; then cp -Rp /build-assets/src/* /assets/install ; fi; \
    if [ -d "/build-assets/scripts" ] ; then for script in /build-assets/scripts/*.sh; do echo "** Applying $script"; bash $script; done && \ ; fi ; \
    if [ -d "/build-assets/custom-scripts" ] ; then mkdir -p /assets/custom-scripts ; cp -Rp /build-assets/custom-scripts/* /assets/custom-scripts ; fi; \
    composer install --ignore-platform-reqs && \
    php artisan freescout:build && \
    rm -rf \
            /assets/install/.env.example \
            /assets/install/.env.travis \
            && \
    chown -R "${NGINX_USER}":"${NGINX_GROUP}" /assets/install && \
    package cleanup && \
    \
    rm -rf /build-assets \
           /root/.composer \
           /var/tmp/*

COPY install /
