FROM docker.io/tiredofit/nginx-php-fpm:8.0
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Defaults
ENV FREESCOUT_VERSION=1.8.4 \
    FREESCOUT_REPO_URL=https://github.com/freescout-helpdesk/freescout \
    NGINX_WEBROOT=/www/html \
    PHP_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_GNUPG=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    CONTAINER_NAME=freescout-app

### Perform Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .freescout-run-deps \
              expect \
              git \
              gnu-libiconv \
              sed \
	      && \
    \
### WWW  Installation
    mkdir -p /assets/install && \
    git clone ${FREESCOUT_REPO_URL} /assets/install && \
    cd /assets/install && \
    git checkout ${FREESCOUT_VERSION} && \
    rm -rf \
        /assets/install/.env.example \
        /assets/install/.env.travis \
        && \
    \
    /usr/sbin/php-ext enable core && \
    composer install --ignore-platform-reqs && \
    chown -R nginx:www-data /assets/install && \
    \
### Cleanup
    rm -rf /root/.composer && \
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Assets
ADD install /
