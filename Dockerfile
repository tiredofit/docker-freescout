FROM tiredofit/nginx-php-fpm:7.3
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Set Defaults
ENV FREESCOUT_VERSION=1.4.6 \
    NGINX_WEBROOT=/www/html \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
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
    curl -sSL https://github.com/freescout-helpdesk/freescout/archive/${FREESCOUT_VERSION}.tar.gz | tar xvfz - --strip 1 -C /assets/install && \
    rm -rf \
        /assets/install/.env.example \
        /assets/install/.env.travis \
        /assets/install/.gitattributes \
        /assets/install/.gitcommit \
        /assets/install/.gitignore \
        && \
    \
    chown -R nginx:www-data /assets/install && \
    \
### Cleanup
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php7

### Assets
ADD install /
