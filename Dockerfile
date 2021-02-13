FROM tiredofit/nginx-php-fpm:7.3
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV FREESCOUT_VERSION=1.6.15 \
    FREESCOUT_REPO_URL=https://github.com/freescout-helpdesk/freescout \
    NGINX_WEBROOT=/www/html \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_CURL=TRUE \
    PHP_ENABLE_FILEINFO=TRUE \
    PHP_ENABLE_ICONV=TRUE \
    PHP_ENABLE_IMAP=TRUE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_OPENSSL=TRUE \
    PHP_ENABLE_SIMPLEXML=TRUE \
    PHP_ENABLE_TOKENIZER=TRUE \
    PHP_ENABLE_ZIP=TRUE \
    ZABBIX_HOSTNAME=freescout-app

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
    composer install && \
    chown -R nginx:www-data /assets/install && \
    \
### Cleanup
    rm -rf /root/.composer && \
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php7

### Assets
ADD install /
