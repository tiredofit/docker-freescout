FROM docker.io/tiredofit/nginx-php-fpm:8.0
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV FREESCOUT_VERSION=1.8.29 \
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
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    IMAGE_NAME="tiredofit/freescout" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-freescout/"

RUN source /assets/functions/00-container && \
    set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .freescout-run-deps \
              expect \
              git \
              gnu-libiconv \
              sed \
	      && \
    \
    php-ext enable core && \
    clone_git_repo ${FREESCOUT_REPO_URL} ${FREESCOUT_VERSION} /assets/install && \
    rm -rf \
        /assets/install/.env.example \
        /assets/install/.env.travis \
        && \
    composer install --ignore-platform-reqs && \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /assets/install && \
    rm -rf /root/.composer && \
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Assets
ADD install /
